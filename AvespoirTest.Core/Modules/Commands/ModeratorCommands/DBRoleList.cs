﻿using AvespoirTest.Core.Attributes;
using AvespoirTest.Core.Database;
using AvespoirTest.Core.Database.Schemas;
using AvespoirTest.Core.Modules.Logger;
using AvespoirTest.Core.Modules.Utils;
using DSharpPlus.Entities;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Tababular;

namespace AvespoirTest.Core.Modules.Commands {

	partial class ModeratorCommands {

		[Command("db-rolelist")]
		public async Task DBRoleList(CommandObjects CommandObject) {
			string[] msgs = CommandObject.CommandArgs.Remove(0);
			IMongoCollection<Roles> DBRolesCollection = MongoDBClient.Database.GetCollection<Roles>(typeof(Roles).Name);

			FilterDefinition<Roles> DBRolesFilter = Builders<Roles>.Filter.Empty;
			List<Roles> DBRolesList = await (await DBRolesCollection.FindAsync(DBRolesFilter).ConfigureAwait(false)).ToListAsync().ConfigureAwait(false);

			List<object> DBRolesObjects = new List<object> { };
			foreach (Roles DBRole in DBRolesList) {
				DBRolesObjects.Add(new { RegisteredID = DBRole.uuid, RegisteredNumber = DBRole.RoleNum, RoleLevel = DBRole.RoleLevel });
			}

			object[] DBRolesArray = DBRolesObjects.ToArray();
			string DBRolesTableText = new TableFormatter().FormatObjects(DBRolesArray);

			await CommandObject.Message.Channel.SendMessageAsync(CommandObject.Message.Author.Mention + "DMをご確認ください！");
			if (string.IsNullOrWhiteSpace(DBRolesTableText)) await CommandObject.Member.SendMessageAsync("何も登録されていません");
			else await CommandObject.Member.SendMessageAsync(DBRolesTableText);
		}

	}
}
﻿using Avespoir.Core.Attributes;
using Avespoir.Core.Modules.LevelSystems;
using Avespoir.Core.Modules.Utils;
using DSharpPlus.Entities;
using DSharpPlus.Exceptions;
using System;
using System.Threading.Tasks;

namespace Avespoir.Core.Modules.Commands {

	partial class PublicCommands {

		[Command("status")]
		public async Task Status(CommandObjects CommandObject) {
			string[] msgs = CommandObject.CommandArgs.Remove(0);
			if (msgs.Length == 0) {
				uint Level = await DatabaseMethods.LevelFind(CommandObject.Message.Author.Id);
				double Exp = await DatabaseMethods.ExpFind(CommandObject.Message.Author.Id);
				if(Exp == 0) {
					await CommandObject.Message.Channel.SendMessageAsync("そのユーザーのステータスは登録されていません");
					return;
				}
				double NextLevelExp = LevelSystem.ReqNextLevelExp(Level) - Exp;

				DiscordMember User = await CommandObject.Guild.GetMemberAsync(CommandObject.Message.Author.Id);

				DiscordEmbed UserStatusEmbed = new DiscordEmbedBuilder()
						.WithTitle(string.Format("{0}のステータス", string.IsNullOrWhiteSpace(User.Nickname) ? User.Username : User.Nickname))
						.WithDescription(string.Format("名前: {0}\nユーザーID: {1}\n経験値: {2}\nレベル: Lv.{3}\n\n次のレベルまであと: {4}", User.Username + "#" + User.Discriminator, User.Id, Exp, Level, NextLevelExp))
						.WithColor(new DiscordColor(0x00B06B))
						.WithTimestamp(DateTime.Now)
						.WithFooter(string.Format("{0} Bot", CommandObject.Client.CurrentUser.Username));

				await CommandObject.Message.Channel.SendMessageAsync(default, default, UserStatusEmbed);
				return;
			}
			else {
				string UserText = msgs[0];
				string UserIDString = UserText.TrimStart('<', '@', '!').TrimEnd('>');
				if (!ulong.TryParse(UserIDString, out ulong UserID)) {
					await CommandObject.Message.Channel.SendMessageAsync("ユーザー指定が不正です");
					return;
				}

				uint Level = await DatabaseMethods.LevelFind(UserID);
				double Exp = await DatabaseMethods.ExpFind(UserID);
				if (Exp == 0) {
					await CommandObject.Message.Channel.SendMessageAsync("そのユーザーのステータスは登録されていません");
					return;
				}
				double NextLevelExp = LevelSystem.ReqNextLevelExp(Level) - Exp;

				try {
					DiscordMember User = await CommandObject.Guild.GetMemberAsync(UserID);

					DiscordEmbed UserStatusEmbed = new DiscordEmbedBuilder()
							.WithTitle(string.Format("{0}のステータス", string.IsNullOrWhiteSpace(User.Nickname) ? User.Username : User.Nickname))
							.WithDescription(string.Format("名前: {0}\nユーザーID: {1}\n経験値: {2}\nレベル: Lv.{3}\n\n次のレベルまであと: {4}", User.Username + "#" + User.Discriminator, UserID, Exp, Level, NextLevelExp))
							.WithColor(new DiscordColor(0x00B06B))
							.WithTimestamp(DateTime.Now)
							.WithFooter(string.Format("{0} Bot", CommandObject.Client.CurrentUser.Username));

					await CommandObject.Message.Channel.SendMessageAsync(default, default, UserStatusEmbed);
				}
				catch (NotFoundException) {
					DiscordEmbed UserStatusEmbed = new DiscordEmbedBuilder()
							.WithTitle(string.Format("{0}のステータス", UserID.ToString()))
							.WithDescription(string.Format("名前: {0}\nユーザーID: {1}\n経験値: {2}\nレベル: Lv.{3}\n\n次のレベルまであと: {4}", "Unknown", UserID, Exp, Level, NextLevelExp))
							.WithColor(new DiscordColor(0x00B06B))
							.WithTimestamp(DateTime.Now)
							.WithFooter(string.Format("{0} Bot", CommandObject.Client.CurrentUser.Username));

					await CommandObject.Message.Channel.SendMessageAsync(default, default, UserStatusEmbed);
				}
			}
		}
	}
}
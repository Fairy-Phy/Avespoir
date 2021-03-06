﻿using Avespoir.Core.Abstructs;
using Avespoir.Core.Attributes;
using Avespoir.Core.Database.Enums;
using Avespoir.Core.Language;
using Avespoir.Core.Modules.Events;
using Avespoir.Core.Modules.Logger;
using System.Threading.Tasks;

namespace Avespoir.Core.Modules.Commands.BotownerCommands {

	[Command("exit", RoleLevel.Owner)]
	class Exit : CommandAbstruct {

		internal override LanguageDictionary Description => new LanguageDictionary("Logout This Bot");

		internal override LanguageDictionary Usage => new LanguageDictionary("{0}exit");

		internal override async Task Execute(CommandObjects CommandObject) {
			await CommandObject.Message.RespondAsync("Logging out...");
			Log.Info("Logging out...");

			await ConsoleExitEvent.Main(0).ConfigureAwait(false);
		}
	}
}

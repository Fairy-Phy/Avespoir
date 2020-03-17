﻿using AvespoirTest.Core;
using AvespoirTest.Core.Configs;
using System;
using System.IO;
using System.Text.Json;

namespace AvespoirTest {

	static class Program {
		
		static void Main(string[] args) {
			// gitignoreで削除しているため事前に用意する必要性あり
			// Projectプロパティから作業ディレクトリを変更してください
			string ClientConfigPath = @"./Configs/ClientConfig.json";
			string DBConfigPath = @"./Configs/DBConfig.json";

			try {
				if (File.Exists(ClientConfigPath) && File.Exists(DBConfigPath)) {
					string ClientConfigJsonData = File.ReadAllText(ClientConfigPath);
					string DBConfigJsonData = File.ReadAllText(DBConfigPath);

					JsonSerializer.Deserialize<GetClientConfigJson>(ClientConfigJsonData);
					JsonSerializer.Deserialize<GetDBConfigJson>(DBConfigJsonData);
				}
				else {
					throw new FileNotFoundException();
				}

				new StartClient();
			}
			catch(FileNotFoundException Error) {
				Console.Error.WriteLine(Error);
			}
		}
	}
}
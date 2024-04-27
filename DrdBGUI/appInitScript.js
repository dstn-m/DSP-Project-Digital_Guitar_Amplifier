importPackage(Packages.com.ti.ccstudio.scripting.environment)

function initTarget() {
	var debugServer = ScriptingEnvironment.instance().getServer("DebugServer.1");

	print("Initializing target : " + appConfigFile+"\n");
	debugServer.setConfig(appConfigFile /* internal variable */);
	var session = debugServer.openSession("*", "*" /* TODO: */);

	//session.options.setBoolean("UseLegacyStopMode", true);
	
	if (!session.target.isConnected()) {
		print("Connecting target: "+session.getName()+"\n");
		session.target.connect();
	}
	
	print("Loading program: "+appProgramFile+"\n");
	session.memory.loadProgram(appProgramFile /* internal variable */);
	
	print("Running Program...\n");
	session.target.runAsynch();
}

initTarget();
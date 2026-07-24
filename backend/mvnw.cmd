@REM ----------------------------------------------------------------------------
@REM Maven Wrapper startup batch script
@REM ----------------------------------------------------------------------------
@IF "%__MVNW_ARG0_NAME__%"=="" (SET "MVN_CMD=mvn") ELSE (SET "MVN_CMD=%__MVNW_ARG0_NAME__%")
@SET MAVEN_WRAPPER_JAR_PATH=%~dp0.mvn\wrapper\maven-wrapper.jar
@SET DOWNLOAD_URL=https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar

@IF EXIST %MAVEN_WRAPPER_JAR_PATH% (
    @IF "%MVNW_VERBOSE%"=="true" @echo Found %MAVEN_WRAPPER_JAR_PATH%
) ELSE (
    @echo Downloading Maven Wrapper...
    @powershell -Command "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%MAVEN_WRAPPER_JAR_PATH%'"
)

@SET MAVEN_USER_HOME=%USERPROFILE%\.m2
@SET M2_HOME=%MAVEN_USER_HOME%
@SET MAVEN_PROJECTBASEDIR=%~dp0

@java -jar "%MAVEN_WRAPPER_JAR_PATH%" %*

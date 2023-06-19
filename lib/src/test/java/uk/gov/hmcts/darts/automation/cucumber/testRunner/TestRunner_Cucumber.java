package uk.gov.hmcts.darts.automation.cucumber.testRunner;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.IncludeTags;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;

//import io.cucumber.junit.platform.engine.Cucumber;

import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.GLUE_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.*;

@Suite
@IncludeEngines("cucumber")
@IncludeTags(value = "Try1")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "pretty")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "html:target/html/results.html")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "uk/gov/hmcts/darts/automation/cucumber/steps")
@SelectClasspathResource(value = "cucumber/features")
public class TestRunner_Cucumber {
}
/*
 * Try1
 * 
 * Regression | DMP-407
 * 
*/
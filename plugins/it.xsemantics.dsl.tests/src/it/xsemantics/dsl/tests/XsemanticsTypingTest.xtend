package it.xsemantics.dsl.tests

import com.google.inject.Inject
import it.xsemantics.dsl.XsemanticsInjectorProvider
import it.xsemantics.dsl.typing.XsemanticsTypingSystem
import it.xsemantics.dsl.util.XsemanticsUtils
import junit.framework.Assert
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.XAbstractFeatureCall
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.xbase.XExpression

@InjectWith(typeof(XsemanticsInjectorProvider))
@RunWith(typeof(XtextRunner))
class XsemanticsTypingTest extends XsemanticsBaseTest {
	
	@Inject
	protected XsemanticsTypingSystem typingSystem
	
	@Inject extension XsemanticsUtils
	
	@Test
	def void testRuleParameterTypes() {
		assertRuleConclusionTypes(testFiles.testSimpleRule, typeof(EClass), typeof(EObject))
	}
	
	@Test
	def void testRuleConclusionTypesWithExpressions() {
		assertRuleConclusionTypes(testFiles.testRuleWithExpressionInConclusion, typeof(EClass), typeof(EObject))
	}
	
	@Test
	def void testRuleInvocation() {
		assertRuleInvocationTypes(testFiles.testRuleInvokingAnotherRule, 0, typeof(EClass), typeof(EClass))
	}
	
	@Test
	def void testBooleanBinaryOr() {
		checkBooleanPremise(getXAbstractFeatureCall(0))
	}
	
	@Test
	def void testBooleanBinaryAnd() {
		checkBooleanPremise(getXAbstractFeatureCall(1))
	}
	
	@Test
	def void testBooleanBinaryEquals() {
		checkBooleanPremise(getXAbstractFeatureCall(2))
	}
	
	@Test
	def void testBooleanBinaryNotEquals() {
		checkBooleanPremise(getXAbstractFeatureCall(3))
	}
	
	@Test
	def void testBooleanBinaryPlus() {
		checkNotBooleanPremise(getXAbstractFeatureCall(4))
	}
	
	@Test
	def void testBooleanMethodCall() {
		checkBooleanPremise(getXAbstractFeatureCall(5))
	}
	
	@Test
	def void testNotBooleanMethodCall() {
		checkNotBooleanPremise(getXAbstractFeatureCall(6))
	}
	
	@Test
	def void testBooleanNegation() {
		checkBooleanPremise(getXAbstractFeatureCall(7))
	}
	
	@Test
	def void testNotBooleanVariableDeclaration() {
		checkNotBooleanPremise(
			testFiles.testForBooleanVariableDeclaration.
				firstVariableDeclaration
		)
	}
	
	@Test
	def void testNotBooleanAssignment() {
		checkNotBooleanPremise(
			testFiles.testForNonBooleanPremises.firstAssignment
		)
	}
	
	@Test
	def void testNotBooleanIf() {
		checkNotBooleanPremise(
			testFiles.testForNonBooleanPremises.firstIf
		)
	}
	
	@Test
	def void testNotBooleanFor() {
		checkNotBooleanPremise(
			testFiles.testForNonBooleanPremises.firstFor
		)
	}
	
	@Test
	def void testEnvironmentAccess() {
		assertEqualsStrings(
			typeof(EClass).name,
			typingSystem.getType(
				testFiles.testWithEnvironmentAccess.parseAndAssertNoError.environmentAccess
			).identifier)
	}
	
	def checkBooleanPremise(XAbstractFeatureCall featureCall) {
		Assert::assertTrue(featureCall.toString,
			typingSystem.isBooleanPremise(featureCall)
		)
	}
	
	def checkNotBooleanPremise(XExpression expression) {
		Assert::assertFalse(expression.toString,
			typingSystem.isBooleanPremise(expression)
		)
	}
	
	def void assertRuleConclusionTypes(CharSequence source, Class leftClass, Class rightClass) {
		val conclusion = source.getFirstRule.conclusion
		Assert::assertEquals(leftClass.name, 
			typingSystem.getType(conclusion.conclusionElements.get(0)).identifier
		)
		Assert::assertEquals(rightClass.name, 
			typingSystem.getType(conclusion.conclusionElements.get(1)).identifier
		)
	}
	
	def void assertRuleInvocationTypes(CharSequence source, int index, Class leftClass, Class rightClass) {
		val invocation = source.firstRule.ruleInvocations.get(index)
		Assert::assertEquals(leftClass.name, typingSystem.getType(invocation.expressions.get(0)).identifier)
		Assert::assertEquals(rightClass.name, typingSystem.getType(invocation.expressions.get(1)).identifier)
	}

}
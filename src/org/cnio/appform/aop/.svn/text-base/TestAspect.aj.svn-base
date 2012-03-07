package org.cnio.appform.aop;

import org.cnio.appform.test.AspectTest;

public aspect TestAspect {
// define pointcut
//	pointcut callBn(B b, C c): target(b) && this(c) && call(void B.n());
	pointcut callMsg ():call (* AspectTest.*());

	// define around advice - changes
	// member values of caller and callee
	before (): callMsg () {
		System.out.println("pointcut callMsg caught!!");
//		a.setMsg ("from aspect");
	}
	
/*
	// test driver
	public static void main(String[] args) {
		C c = new C();
		c.m();
	}
*/
}

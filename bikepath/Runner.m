#import "Example.h"

int main ()
{
    /* local variable definition */
    int a = 100;
    int b = 200;
    int ret;

    SampleClass *sampleClass = [[SampleClass alloc]init];

    /* calling a method to get max value */
    ret = [sampleClass max:a andNum2:b];

    NSLog(@"Max value is : %d\n", ret );
    NSLog(@"Max value is : %d\n", ret );

    return 0;
}

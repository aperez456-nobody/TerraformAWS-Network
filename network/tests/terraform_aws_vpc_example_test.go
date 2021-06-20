package tests

import (
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestTerraformAwsVpcExample(t *testing.T)  {
	t.Parallel()

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	environment := "Test"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region":          awsRegion,
			"environment":     environment,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	vpcId := terraform.Output(t, terraformOptions, "main_vpc_id")

	subnets := aws.GetSubnetsForVpc(t, vpcId, awsRegion)

	require.Equal(t, 6, len(subnets))

	for _, publicSubnetId := range publicSubnetIds {
		assert.True(t, aws.IsPublicSubnet(t, publicSubnetId, awsRegion))
	}

	for _, privateSubnetId := range privateSubnetIds {
		assert.False(t, aws.IsPublicSubnet(t, privateSubnetId, awsRegion))
	}

}

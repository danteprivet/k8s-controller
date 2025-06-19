package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var goBasicCmd = &cobra.Command{
	Use: "go-basic",
	Short: "Run golang basic code",
	Run: func(cmd *cobra.Command, args []string) {
		k8s := Kubernetes{
		    Name:    "k8s-demo-cluster",
			Version: "1.31",
			Users:   []string{"alex", "den"},
			NodeNumber: func() int {
				return 10
			},
		}

		k8s.GetUsers()

		k8s.AddNewUser("anonymous")

		k8s.GetUsers()

	},
}


func init() {
	rootCmd.AddCommand(goBasicCmd)
}


type Kubernetes struct {
	Name       string     `json:"name"`
	Version    string     `json:"version"`
	Users      []string   `json:"users,omitempty"`
	NodeNumber func() int `json:"-"`
}

func (k8s Kubernetes) GetUsers() {
	for _, user := range k8s.Users {
		fmt.Println(user)
	}
}

func (k8s *Kubernetes) AddNewUser(user string) {
	k8s.Users = append(k8s.Users, user)
}
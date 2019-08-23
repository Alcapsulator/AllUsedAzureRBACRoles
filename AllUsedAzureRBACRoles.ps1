try {

    function ConnectAzureAD {
        connect-azuread
    }

    function GetRBACRoles($roles) {
        $rbac_roles = @()
        Foreach ($r in $roles) {
            GetRBACRoleMembers $r.ObjectId
        }
        return $rbac_roles
    }

    function GetRBACRoleMembers($currentrole) {
        $rbac_members = @()
        Foreach($u in Get-AzureADDirectoryRoleMember -ObjectId $currentrole) {
            $rbac_members += [PSCustomObject]@{Role_OId = $r.ObjectId; Role=$r.DisplayName; Description=$r.Description; Member = $u.Displayname }
        }
        return $rbac_members
    }

    Echo "[INFO] - Connecting with Azure"
    ConnectAzureAD

    $roles = Get-AzureADDirectoryRole

    Echo "[INFO] - Getting all roles"
    $myrole = GetRBACRoles $roles

    Echo "[INFO] - Finished getting roles (Found: $($myrole.count))"
    $myrole | export-csv rbac_roles.csv -Append -force
    Echo "[INFO] - Ceated csv-list -> Saved @ $(Get-Location)rbac_roles.csv"

    pause | out-null
} catch {
    echo "Erorr $($_.Exception.Message)"
    pause
    break
}

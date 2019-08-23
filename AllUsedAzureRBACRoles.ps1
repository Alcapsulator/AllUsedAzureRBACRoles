try {

    $roles = Get-AzureADDirectoryRole

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

    Echo "Getting all roles"
    $myrole = GetRBACRoles $roles

} catch {
    echo "Erorr $($_.Exception.Message)"
    pause
    break
}
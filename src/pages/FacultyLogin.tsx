import LoginForm from "@/components/LoginForm";

export default function FacultyLogin() {
  return (
    <LoginForm
      title="Faculty / Admin Login"
      subtitle="Access faculty & administration portal"
      allowedPrefixes={["FAC", "AD", "SA"]}
      placeholderId="e.g. FAC001, AD001, SA001"
      demoCredentials={[
        { label: "Super Admin", id: "SA001", password: "SuperAdmin@123" },
        { label: "Admin", id: "AD001", password: "Admin@123" },
        { label: "Faculty", id: "FAC001", password: "Faculty@123" },
      ]}
    />
  );
}

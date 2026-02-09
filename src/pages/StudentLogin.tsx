import LoginForm from "@/components/LoginForm";

export default function StudentLogin() {
  return (
    <LoginForm
      title="Student Login"
      subtitle="Access your academic portal"
      allowedPrefixes={["STU"]}
      placeholderId="e.g. STU001"
      demoCredentials={[{ label: "Student", id: "STU001", password: "Student@123" }]}
    />
  );
}

import { useState, useEffect } from "react";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import Starfield from "@/components/Starfield";
import { Card, CardContent } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Users, MapPin, Calendar } from "lucide-react";

interface Member {
  id: string;
  full_name: string;
  avatar_url?: string;
  location?: string;
  joined_date: string;
  role?: string;
}

const Members = () => {
  const [members, setMembers] = useState<Member[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Mock data for demonstration
    // In production, fetch from your database
    const mockMembers: Member[] = [
      {
        id: "1",
        full_name: "Ahmed Hassan",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Ahmed",
        location: "Cairo, Egypt",
        joined_date: "2024-01-15",
        role: "Seller"
      },
      {
        id: "2",
        full_name: "Sarah Mohamed",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah",
        location: "Dubai, UAE",
        joined_date: "2024-02-20",
        role: "Buyer"
      },
      {
        id: "3",
        full_name: "Omar Ali",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Omar",
        location: "Riyadh, Saudi Arabia",
        joined_date: "2024-03-10",
        role: "Seller"
      },
      {
        id: "4",
        full_name: "Layla Ibrahim",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Layla",
        location: "Amman, Jordan",
        joined_date: "2024-01-25",
        role: "Buyer"
      },
      {
        id: "5",
        full_name: "Khaled Mahmoud",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Khaled",
        location: "Beirut, Lebanon",
        joined_date: "2024-02-05",
        role: "Seller"
      },
      {
        id: "6",
        full_name: "Fatima Youssef",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Fatima",
        location: "Casablanca, Morocco",
        joined_date: "2024-03-15",
        role: "Buyer"
      }
    ];

    setTimeout(() => {
      setMembers(mockMembers);
      setLoading(false);
    }, 500);
  }, []);

  const getInitials = (name: string) => {
    return name
      .split(" ")
      .map((n) => n[0])
      .join("")
      .toUpperCase()
      .slice(0, 2);
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString("en-US", { month: "short", year: "numeric" });
  };

  return (
    <div className="min-h-screen flex flex-col">
      <Starfield />
      <Navbar />
      
      <main className="flex-1 container mx-auto px-4 py-12 relative z-10">
        {/* Hero Section */}
        <div className="text-center mb-12 space-y-4">
          <div className="flex items-center justify-center gap-2 mb-4">
            <Users className="h-8 w-8 text-primary" />
            <h1 className="text-4xl md:text-5xl font-bold">Community Members</h1>
          </div>
          <p className="text-muted-foreground text-lg max-w-2xl mx-auto">
            Meet the amazing members of our marketplace community
          </p>
        </div>

        {/* Members Grid */}
        {loading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
              <Card key={i} className="overflow-hidden">
                <CardContent className="p-6">
                  <div className="flex items-start gap-4">
                    <Skeleton className="h-16 w-16 rounded-full" />
                    <div className="flex-1 space-y-2">
                      <Skeleton className="h-5 w-32" />
                      <Skeleton className="h-4 w-24" />
                      <Skeleton className="h-4 w-28" />
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {members.map((member) => (
              <Card 
                key={member.id} 
                className="overflow-hidden hover:shadow-lg transition-all duration-300 hover:scale-[1.02] cursor-pointer"
              >
                <CardContent className="p-6">
                  <div className="flex items-start gap-4">
                    <Avatar className="h-16 w-16 border-2 border-primary/20">
                      <AvatarImage src={member.avatar_url} alt={member.full_name} />
                      <AvatarFallback className="bg-primary/10 text-primary font-semibold">
                        {getInitials(member.full_name)}
                      </AvatarFallback>
                    </Avatar>
                    
                    <div className="flex-1 space-y-2">
                      <div className="flex items-center justify-between">
                        <h3 className="font-semibold text-lg">{member.full_name}</h3>
                        {member.role && (
                          <Badge variant="secondary" className="text-xs">
                            {member.role}
                          </Badge>
                        )}
                      </div>
                      
                      {member.location && (
                        <div className="flex items-center gap-1.5 text-sm text-muted-foreground">
                          <MapPin className="h-3.5 w-3.5" />
                          <span>{member.location}</span>
                        </div>
                      )}
                      
                      <div className="flex items-center gap-1.5 text-sm text-muted-foreground">
                        <Calendar className="h-3.5 w-3.5" />
                        <span>Joined {formatDate(member.joined_date)}</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {!loading && members.length === 0 && (
          <div className="text-center py-12">
            <Users className="h-16 w-16 mx-auto text-muted-foreground mb-4" />
            <h3 className="text-xl font-semibold mb-2">No members yet</h3>
            <p className="text-muted-foreground">Be the first to join our community!</p>
          </div>
        )}
      </main>

      <Footer />
    </div>
  );
};

export default Members;


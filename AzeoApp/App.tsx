import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Text } from 'react-native';
import { UserProvider } from './context/UserContext';
import InputScreen from './screens/InputScreen';
import ProfileScreen from './screens/ProfileScreen';

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <UserProvider>
      <NavigationContainer>
        <Tab.Navigator
          screenOptions={{
            tabBarActiveTintColor: '#FF6B35',
            tabBarInactiveTintColor: '#94A3B8',
            tabBarStyle: {
              backgroundColor: 'white',
              borderTopWidth: 0,
              elevation: 8,
              shadowColor: '#000',
              shadowOffset: { width: 0, height: -2 },
              shadowOpacity: 0.1,
              shadowRadius: 8,
              height: 60,
              paddingBottom: 8,
              paddingTop: 8,
            },
            tabBarLabelStyle: {
              fontSize: 12,
              fontWeight: '600',
              letterSpacing: 0.5,
            },
            headerStyle: {
              backgroundColor: '#2D2E5F',
              elevation: 0,
              shadowOpacity: 0,
            },
            headerTintColor: 'white',
            headerTitleStyle: {
              fontWeight: '700',
              fontSize: 18,
              letterSpacing: 0.5,
            },
          }}
        >
          <Tab.Screen
            name="Input"
            component={InputScreen}
            options={{
              title: 'Saisir User ID',
              tabBarLabel: 'Sélection',
              tabBarIcon: ({ color, size }) => (
                <Text style={{ fontSize: 24, color }}>✏️</Text>
              ),
            }}
          />
          <Tab.Screen
            name="Profile"
            component={ProfileScreen}
            options={{
              title: 'Profil Utilisateur',
              tabBarLabel: 'Profil',
              tabBarIcon: ({ color, size }) => (
                <Text style={{ fontSize: 24, color }}>👤</Text>
              ),
            }}
          />
        </Tab.Navigator>
      </NavigationContainer>
    </UserProvider>
  );
}
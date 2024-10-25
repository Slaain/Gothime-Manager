import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { AntDesign, Ionicons } from '@expo/vector-icons';
import FontAwesome6 from '@expo/vector-icons/FontAwesome6';
import FontAwesome5 from '@expo/vector-icons/FontAwesome5';
import Entypo from '@expo/vector-icons/Entypo';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';

function MyTabBar({ state, descriptors, navigation, pathname }) {

  const colors = { primary: "#FDCB12" };

  const icons = {
    index: (props) => <Entypo name="home" size={22} color={"#222"} {...props} />,
    camera: (props) => <AntDesign name="camera" size={22} color={"#222"} {...props} />,
    explore: (props) => <Ionicons name="stats-chart" size={22} color={"#222"} {...props} />,
  };

  const tabBarRoutes = ['/', '/explore', '/camera'];


  return (
    <View style={styles.tabbar} >
      {
        state.routes.map((route, index) => {
          // console.log("route : ", route.name);
          // console.log("verif : , ", !tabBarRoutes.includes(pathname));

          if (!tabBarRoutes.includes(pathname)) {
            return null;
          }

          if (!(route.name === "index" || route.name === "explore" || route.name === "camera")) {
            // console.log("true : ", route.name);

            return null;
          }

          // console.log(route.name);

          const { options } = descriptors[route.key];
          const label =
            options.tabBarLabel !== undefined
              ? options.tabBarLabel
              : options.title !== undefined
                ? options.title
                : route.name;

          if (['_sitemap', '+not-found'].includes(route.name)) {
            return null;
          }

          const isFocused = state.index === index;

          const onPress = () => {
            const event = navigation.emit({
              type: 'tabPress',
              target: route.key,
              canPreventDefault: true,
            });

            if (!isFocused && !event.defaultPrevented) {
              navigation.navigate(route.name, route.params);
            }
          };

          const onLongPress = () => {
            navigation.emit({
              type: 'tabLongPress',
              target: route.key,
            });
          };

          // Vérifie si la route existe dans icons
          const IconComponent = icons[route.name] || (() => <View />);

          return (
            <TouchableOpacity
              key={route.key}
              style={styles.tabbarItem}
              accessibilityRole="button"
              accessibilityState={isFocused ? { selected: true } : {}}
              accessibilityLabel={options.tabBarAccessibilityLabel}
              testID={options.tabBarTestID}
              onPress={onPress}
              onLongPress={onLongPress}
              style={{ flex: 1 }}
            >
              <View
                style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
                <IconComponent
                  style={{
                    color: isFocused ? "white" : '#222',
                    marginBottom: 3,
                    backgroundColor: isFocused ? colors.primary : 'transparent',
                    padding: 8,
                    borderRadius: 8
                  }}
                />
              </View>
            </TouchableOpacity>
          );
        })
      }
    </View >
  );
}


const styles = StyleSheet.create({
  tabbar: {
    position: 'absolute',
    bottom: 15,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: "#fff",
    marginHorizontal: 10,
    paddingVertical: 10,
    borderRadius: 8,
    borderCurve: "continuous",
    shadowColor: "#000",
    shadowOffset: {
      width: 0,
      height: 15, // Augmenté pour une ombre plus basse
    },
    shadowRadius: 20, // Augmenté pour une ombre plus diffuse
    shadowOpacity: 0.35, // Augmenté pour rendre l'ombre plus visible
    elevation: 10, // Augmenté pour Android
    width: "60%",
    alignSelf: 'center',
  },
  tabbarItem: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  }
});


export default MyTabBar;
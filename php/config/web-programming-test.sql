-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 13, 2023 at 01:39 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web-programming`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_cart_item_price` (IN `cart_id` INT, IN `product_id` INT)   BEGIN

        DECLARE pprice DECIMAL(10, 2) unsigned DEFAULT 0;
				SET pprice = ( SELECT price FROM product WHERE id = product_id );
        
        UPDATE cart_item 
        SET total_price = pprice * quantity
        WHERE cart_id = cart_id AND product_id = product_id;

    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_cart_total_price` (IN `new_cart_id` INT)   BEGIN
				DECLARE discount_amount DECIMAL ( 10, 2 ) DEFAULT 0;
        DECLARE original_price DECIMAL ( 10, 2 ) DEFAULT 0;
        
        SET discount_amount = (
            SELECT SUM( p.discount )
            FROM cart_promotion cp JOIN promotion p ON cp.promotion_code = p.CODE 
            WHERE cp.cart_id = new_cart_id AND p.STATUS = 'ACTIVE' );
        SET original_price = ( SELECT SUM( ci.total_price ) FROM cart_item ci WHERE ci.cart_id = new_cart_id );
				SET original_price = COALESCE(original_price, 0);
				SET discount_amount = COALESCE(discount_amount, 0);
        
        UPDATE cart
        SET total = original_price - discount_amount * 0.01 * original_price
        WHERE id = new_cart_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkout` (IN `new_cart_id` INT)   BEGIN
		DECLARE `done` BOOL DEFAULT FALSE;
		DECLARE `pid` INT;
		DECLARE `pquantity` INT;
		DECLARE `cur1` CURSOR FOR 
            SELECT ci.product_id, ci.quantity
            FROM `cart_item` ci 
		    WHERE ci.cart_id = new_cart_id;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

		OPEN `cur1`;
		`cart_item_loop` :		LOOP
			IF `done` THEN
				LEAVE `cart_item_loop`;
			END IF;

			FETCH `cur1` INTO `pid`, `pquantity`;
			
			UPDATE product
			SET quantity = quantity - pquantity
			WHERE id = pid;
			
			SET `pid` = 0;
			
		END LOOP `cart_item_loop`;
		CLOSE `cur1`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `set_promotion_status` ()   BEGIN
		UPDATE promotion 
		SET status = 
			CASE
				WHEN CURDATE() < start_date then 'INACTIVE'
				WHEN CURDATE() >= start_date AND CURDATE() <= end_date THEN 'ACTIVE'
				ELSE 'EXPIRE'
			END;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blog`
--

CREATE TABLE `blog` (
  `id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `blog`
--

INSERT INTO `blog` (`id`, `author_id`, `title`, `content`, `image_url`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Valve starts selling refurbished Steam Decks for up to $130 less than new models', 'Valve\'s Steam Deck hardware has been consistently available to buy for over a year now, but if the price has put you off, Valve has a new option for you. The company is now selling official, certified-refurbished Steam Decks with the same one-year warranty as new models at prices that are between $80 and $130 lower, depending on the configuration you want.\r\n\r\nA basic Steam Deck with 64GB of eMMC storage costs $319 refurbished, compared to $399 new. The 256GB model runs $419 refurbished, compared to $529 new. And the 512GB model costs $519, compared to $649 new. All have the same Zen 2-based AMD CPU and integrated Radeon GPU, the same 16GB of LPDDR5 RAM, a charger, and a carrying case. Buying refurbished hardware directly from the manufacturer—from Apple\'s refurbished site, the Dell Outlet, and other places—is usually a great way to get like-new hardware for less money without sacrificing software and warranty support as you might if you bought from a third party.\r\n\r\nIf you want to save even more money on a Steam Deck, consider that iFixit, Framework, and a growing number of SSD makers are also releasing (physically) smaller SSD models that users can buy to save some money on storage or upgrade beyond that 512GB maximum.\r\n\r\nValve says the hardware is guaranteed to work like new, though refurbished units may have cosmetic defects that don\'t affect functionality.\r\n\r\n\"Each Certified Refurbished Steam Deck has been thoroughly tested to the same high standards as our retail units,\" says Valve. \"Every device goes through a complete factory reset, software update, and an extensive examination involving over 100 tests at one of Valve\'s facilities. Among the tests are all controller inputs, the audio system, the screen, and internals. Battery health is also assessed to ensure proper functionality and longevity. All refurbished units meet or even exceed the performance standards of new retail units. Although they may have minor cosmetic blemishes, they provide a reliable, high-quality gaming experience at a lower cost.\"\r\n\r\nThe Steam Deck\'s hardware has already been superseded by newer CPUs and GPUs like the Ryzen Z1 in Windows-powered handhelds like the Asus ROG Ally. And Valve has said that it\'s in no rush to put out a major upgrade, preferring instead to stick to a more console-esque upgrade timeline that gives developers a slower-but-stable configuration to target.\r\n\r\nBut as we discovered in our testing, Windows still isn\'t well-suited for handheld PCs, and third-party SteamOS distributions for handhelds like the Ally also aren\'t all there. For many players\' day-to-day experience, it\'s still worth giving up some extra frames-per-second to get the niceties of official first-party SteamOS support.', '/images/blogs/valve-deck.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(2, NULL, 'AI researchers claim 93% accuracy in detecting keystrokes over Zoom audio', 'By recording keystrokes and training a deep learning model, three researchers claim to have achieved upwards of 90 percent accuracy in interpreting remote keystrokes, based on the sound profiles of individual keys.\r\n\r\nIn their paper A Practical Deep Learning-Based Acoustic Side Channel Attack on Keyboards (full PDF), UK researchers Joshua Harrison, Ehsan Toreini, and Marhyam Mehrnezhad claim that the trio of ubiquitous machine learning, microphones, and video calls \"present a greater threat to keyboards than ever.\" Laptops, in particular, are more susceptible to having their keyboard recorded in quieter public areas, like coffee shops, libraries, or offices, the paper notes. And most laptops have uniform, non-modular keyboards, with similar acoustic profiles across models.\r\n\r\nPrevious attempts at keylogging VoIP calls, without physical access to the subject, achieved 91.7 percent top-5 accuracy over Skype in 2017 and 74.3 percent accuracy in VoIP calls in 2018. Combining the output of the keystroke interpretations with a \"hidden Markov model\" (HMM), which guesses at more-likely next-letter outcomes and could correct \"hrllo\" to \"hello,\" saw one prior side channel study\'s accuracy jump from 72 to 95 percent—though that was an attack on dot-matrix printers. The Cornell researchers believe their paper is the first to make use of the recent sea change in neural network technology, including self-attention layers, to propagate an audio side channel attack.\r\n\r\nThe researchers used a 2021 MacBook Pro to test their concept, a laptop that \"features a keyboard identical in switch design to their models from the last two years and potentially those in the future,\" typing on 36 keys 25 times each to train their model on the waveforms associated with each key. They used an iPhone 13 mini, 17 cm away, to record the keyboard\'s audio for their first test. For the second test, they recorded the laptop keys over Zoom, using the MacBook\'s built-in microphones, with Zoom\'s noise suppression set to its lowest level. In both tests, they were able to achieve higher than 93 percent accuracy, with the phone-recorded audio edging closer to 95-96 percent.\r\n\r\nThe researchers noted that the position of a key seemed to play an important role in determining its audio profile. Most false-classifications, they wrote, tended to be only one or two keys away. Because of this, the potential for a second machine-bolstered system to correct the false keys, given a large language corpus and the approximate location of a keystroke, seems strong.\r\n\r\nWhat could be done to mitigate these kinds of attacks? The paper suggests a few defenses:\r\n\r\n    Changing your typing style, with touch typing in particular being less accurately recognized\r\n    Using randomized passwords with multiple cases, since these attacks struggle to recognize the \"release peak\" of a shift key\r\n    Adding randomly generated false keystrokes to the transmitted audio of video calls, though this \"may inhibit usability of the software for the receiver.\"\r\n    Use of biometric tools, like fingerprint or face scanning, rather than typed passwords\r\n\r\nPersonally, I take this as validation of my impulse to maintain a collection of mechanical keyboards with different switch types, but the researchers had no particular say on that strategy.\r\n\r\nSound-based side channel attacks on sensitive computer data are sometimes seen in research, though rarely in disclosed breaches. Scientists have used computer sounds to read PGP keys, and machine learning and webcam mics to \"see\" a remote screen. Side channel attacks themselves are a real threat, however. The 2013 \"Dropmire\" scandal that saw the US spying on its European allies was highly likely to have involved some kind of side channel attack, whether through wires, radio frequencies, or sound.', '/images/blogs/ai-researchers-keyboard-audio.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(3, NULL, 'Turning my Framework laptop into a tiny desktop was fun. Now it needs a job.\r\n', 'Many industry pundits were skeptical when the new laptop company Framework announced a repair-friendly, upgrade-ready laptop in 2021. Could you really swap parts between laptops—reasonably thin and lightweight laptops—year over year? Would that even work as a business model?\r\n\r\nFramework released the first edition of its machine, and we found that it lived up to its promises. The company followed through with a second-generation laptop, and we reviewed the third iteration as \"a box of parts\" that upgraded the previous version. The upgrade experiment has been a success. All that\'s left are, well, the parts left behind.\r\n\r\nIt\'s 2023, and those who have Framework\'s first generation of laptops, containing Intel\'s 11th-generation Core processor) might be itching to upgrade, especially with an AMD model around the corner. Or maybe, like me, they find that system\'s middling battery life and tricky-to-tame sleep draining (since improved, but not entirely fixed) make for a laptop that doesn\'t feel all that portable. Or they\'re just ready for something new.\r\n\r\nWhat can you do with these old internal organs? You can always list them for sale. Or, like me, you could buy a custom-printed Cooler Master case (or 3D-print your own), transfer your laptop\'s mainboard, memory, and storage over, and create a desktop that easily fits on top of your actual desk. I can\'t recommend it enough as a small weekend project, as a way to get more value out of your purchase, and as a thought experiment in what kind of job you can give to a thin little slab of Framework.\r\nGathering your parts and tools\r\n\r\nIt was easy to miss the announcement earlier this year that Framework would collaborate with Cooler Master to design and sell a $40 mainboard case. It\'s custom-built to the Framework board\'s persistent shape, so it works for whatever version of the Framework 13 laptop you have. It has smoked translucent plastic on the front and inoffensive light gray/beige on the back, and it has all the slots necessary for fan intake and exhaust, the Framework\'s USB-C expansion modules, and VESA mounts or a tiny rubberized stand. And there\'s a little power button.\r\n\r\nI had an 11th-gen i7 Framework, plus a good number of expansion ports. One issue I knew I\'d see was the Intel AX200-series card inside, which I\'ve seen some Linux-based systems (including ChromeOS) complain about. So I added Framework\'s own Ethernet expansion card to my order. This was far from necessary, as I could have used any Ethernet-to-USB-C converter and plugged it into the USB-C receiver for an expansion card. But I preferred the clear plastic to the dongle, so I added it to my order.\r\n\r\nThere\'s room in the case to bring over your audio board (i.e., headphone jack) and a Wi-Fi/Bluetooth card, though you\'ll have to buy your own SMA antenna cable setup. If you know you aren\'t going to use the Framework chassis again and really want Wi-Fi inside your new slab, you could probably pluck the antennae from inside the case, hinge, and monitor bezel, but there\'s no repair guide for that yet.\r\nEmptying out a laptop\r\n\r\nThere\'s no heroic, hacky story to be had in pulling the mainboard out of a Framework laptop, because it\'s designed to be done by anybody. There\'s an official guide, primarily written by the company\'s CEO, showing the steps needed to get the device open using just a Phillips and T5 Torx driver (included with the device) and your hands.\r\n\r\nThe trickiest part is getting the tiny antenna cables out of the way. Otherwise, you pull a few connectors and flip a few flex cable latches, and you\'re eventually left with a separated brain and body.\r\n\r\nYou can keep the storage and memory in your mainboard as-is, but it\'s a good time to upgrade if you\'re thinking about it. I decided to stick with the 500GB WD_Black SN750 NVME drive and 16GB of Crucial RAM I had inside. Paired with the 11th-Gen i7-1165G7 at 2.8 GHz on 8 cores, I had plenty of power for this very secondary computer. Later on, after a few weeks\' use, I went back into my laptop and brought over the headphone jack. There is something to be said for having an analog fallback, and I missed it.\r\nUsing the Framework “slabtop” (with Linux)\r\n\r\nFramework modules fit two on each side in press-to-release slots, just like the laptop. That\'s a boon for cable management, allowing you to put whichever ports you want facing either way. If you need more USB-C ports, you can pop out a module and use its connecting port, provided your cable fits.\r\n\r\nFor my purposes, I needed a USB-C port for dedicated power (the default charger is 60 W), another USB-C for my monitor connection (with my monitor acting as a USB hub for peripherals), Ethernet through the expansion card, and then a USB-A, just because.\r\n\r\nMy Framework originally ran Windows, but I wanted to start fresh in this new form factor. I tried out ChromeOS Flex and it worked fine, no longer blocked by an incompatible Intel Wi-Fi card. But I wanted to run a few apps, including Steam, that felt cramped in ChromeOS, so I moved on to Linux.\r\n\r\nLinux on a Framework is an interesting proposition. Framework has gone out of its way in recent years to encourage all kinds of Linux distros and tinkering on their systems. The company offers its DIY Edition laptop with no OS, and it chooses components based in part on not having to generate new kernel drivers. Framework makes firmware updates available to Linux users at the same time as Windows and actively participates in community forum posts about Linux issues.\r\n\r\nRecently, though, the growing but still early days company has limited its efforts to a few \"officially supported\" (Ubuntu, Fedora) and \"community supported\" (Manjaro, Linux Mint) distros. After reviewing the Pangolin laptop, I became partial to System76\'s Pop!_OS. Framework can\'t keep on top of Pop!_OS\'s \"growing incompatibility issues\" at even a community support level. So my support will largely come from deep searches of a few Framework forum threads.\r\n\r\nDoes this matter? Not really. When you strip away a screen, speakers, microphone, Wi-Fi, fingerprint scanner, webcam, keyboard, trackpad, and any real need for fine-tuned battery and power management, it\'s not too hard to make any relatively modern Linux distro work. I loaded up a USB stick, installed Pop!_OS on the storage, and that was it. I\'ve been working from my Framework \"slabtop\" (as I refuse to stop calling it) on and off for weeks, and I\'ve made zero changes to any system files.\r\n\r\nThe most surprising thing I\'ve noticed is how quiet an 11th-gen, i7-based Framework system can be when it\'s not a laptop. Working with Firefox, Slack, a messaging app, and a few other apps open, I hardly ever hear the fan except when encountering one of those awful ad-strewn websites that tax us all. I don\'t know if it\'s the new space and ventilation, the lack of a big and active battery nearby, or a decided lack of Windows, but it feels like a free upgrade.\r\n\r\nThen there are the other perks. The Framework laptop\'s mainboard has little side LEDs that blink 22 times on boot-up! And you can see every weird, indecipherable color through the Cooler Master case. It\'s a little celebration of hardware interoperability every time I boot up. And there\'s the minimal size and weight of this thing. It\'s the only desktop computer I\'ve ever used that I can tuck away in a drawer. My monitor doesn\'t allow me to mount the slabtop onto the back of it, using the two-headed bolts that come with the case, but it\'s an idea for the future.\r\nMy fondness for the transplanted Framework board is surpassed only by my cat Cork\'s, who absolutely adores its thermal properties.\r\nMy fondness for the transplanted Framework board is surpassed only by my cat Cork\'s, who absolutely adores its thermal properties.\r\nKevin Purdy\r\nWhat else could I do with this slab?\r\n\r\nRight now, my Framework slab is like a midrange motorcycle, filling in whenever I don\'t need the pickup truck (gaming PC tower) or sedan (M2 MacBook Air), and it\'s doing fine at that job. But I tinkered with a few ideas for it that didn\'t quite pan out, for various reasons:\r\n\r\n    Dedicated Plex server (I actually don\'t have that much media to dish out)\r\n    TrueNAS backup server (TrueNAS and its adherents absolutely loathe the use of external USB drives in pools)\r\n    Home Assistant (Too powerful; I already have a Raspberry Pi 4 for the job)\r\n    Docker server with containers for Home Assistant, Plex, Wireguard VPN, streaming music server, etc. (I\'m not good enough with Docker... yet?)\r\n\r\nI have yet to even venture into some farther-out ideas, like creating an overpowered DIY set-top streaming box (what remote would you even use?) or the like. So I put it to our readers: What would you do if you had a 2-year-old laptop core, with hot-swap ports, inside a case you could easily tuck away somewhere?\r\n', '/images/blogs/framework-laptop-case.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(4, NULL, 'Cortana, once a flagship feature of Windows phones, is slowly being shut down', 'Microsoft is working to cram its new ChatGPT-powered Bing Chat service into every product it makes, and starting this fall it will be a built-in feature of Windows 11. It makes sense, then, that Microsoft is also working to shut down its last stab at an automated virtual assistant—the standalone Cortana app in Windows 10 and Windows 11 is going to stop working this month, and Microsoft is pointing users toward Bing Chat and Windows Copilot instead.\r\n\r\nSome users have reported that the Cortana app has already stopped working entirely following an app update. On a PC running a fully up-to-date version of Windows 11 22H2, my Cortana app still functions, but it told me that \"Cortana in Windows is going away soon.\"\r\n\r\nMicrosoft has been pulling back on its support for Cortana for years, ending support for the iOS and Android versions in early 2021 and removing it from the Windows taskbar in Windows 11 a few months later. Before that, Microsoft had already removed most third-party app integrations, refocusing the assistant entirely on basic productivity tasks and Bing searches.\r\n\r\nCortana began life on Microsoft’s ill-fated Windows Phone platform in the early 2010s, where it served the same general function as Apple’s Siri and Google Now (and, later, the Google Assistant): a hands-free way to interact with your phone that also attempted to predict what you\'d need next, all filtered through a \"cute\" \"personality.\"\r\n\r\nCortana came to the desktop with Windows 10 in 2015, and to Android and iOS a few months after that. By 2019, the voice assistant was already being gradually deprioritized in new Windows 10 builds.\r\n\r\nIn addition to Windows Copilot, Microsoft says that people who rely on Cortana in Windows should also consider using the \"voice access\" accessibility feature in Windows 11, which supports speech-to-text capabilities and limited window management even if your computer doesn\'t have an active Internet connection.\r\n\r\nFor now, Microsoft says that Cortana will still be included in Microsoft Outlook and Microsoft Teams. Those versions of Cortana are also likely to be swept away by new AI-driven versions, eventually. Before too long, it may only be possible to hear Cortana in its original form: as an AI helper in the Halo franchise.\r\n\r\nListing image by Cortana', '/images/blogs/cortana-windows.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(5, NULL, 'Linux surpasses the Mac among Steam gamers', 'Apple\'s macOS has been the second most popular operating system on the Steam game distribution platform for a long time, but that has now changed. Linux has surpassed macOS for the No. 2 spot, according to Steam\'s July user hardware survey.\r\n\r\nSteam regularly asks its users to give an anonymized look at their hardware, and the company makes the information it gathers available each month.\r\n\r\nFurther Reading\r\nLinux could be 3% of global desktops. What happened to Windows?\r\nIn July\'s survey, Windows was still reported by 96.21 percent of users\' systems, so regardless of whether Linux or macOS come in second, it\'s a decidedly distant second. Linux managed 1.96 percent, while macOS accounted for 1.84 percent of machines.\r\n\r\nThat\'s more than half a percent jump over June for Linux, and as Phoronix noted, it puts Linux close to its all-time high, which was only slightly higher many years ago when Steam had far fewer users overall.\r\n\r\nBut before you declare this a triumphant moment for desktop Linux, it\'s important to note that some of these Linux users are not, in fact, using Steam on a desktop. The Linux version \"SteamOS Holo\" 64-bit is the most popular reported, at just over 42 percent of the Linux slice of pie. That indicates that a huge portion of these Linux users are actually playing on Valve\'s Steam Deck portable, which runs Linux.\r\n\r\nOf course, there can be some variance in the results from month to month, depending on who opts into the survey. But that variance is usually smaller than this, given the scale at which Steam runs these surveys.\r\n\r\nThe Steam Deck was first released a while ago, but it only became widely available without a waiting list last October. We\'re likely seeing the result of a solid adoption rate since then.\r\n\r\nThere\'s another factor that could be at play on the desktop, too, though. Last month, Steam made some big changes under the hood to how the desktop application worked on Linux and macOS, some of which were built on the work done on Steam Deck. The app runs better on both platforms, though the difference was more dramatic on macOS.\r\n\r\nMeanwhile, Apple has been making a lot of noise about making the Mac a more viable gaming platform, given the exceptionally strong graphics performance (for integrated graphics on a laptop, at least) of the M1 and M2 series chips in the latest Macs.\r\n\r\nIt worked with game publishers to see high-profile releases like Resident Evil Village and No Man\'s Sky in recent months, and those games run pretty well on modern Macs—certainly better than similar titles on Intel-based Macs with integrated graphics chips. It also announced a new gaming porting tool in an upcoming version of macOS that works in some ways like Proton, as seen on the Steam Deck.\r\n\r\nLooking at Steam\'s numbers, though, Apple clearly has a long way to go.', '/images/blogs/valve-deck-in-case.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(6, NULL, 'ChromeOS is splitting the browser from the OS, getting more Linux-y', 'It looks like Google\'s long-running project to split up ChromeOS and its Chrome browser will be shipping out to the masses soon. Kevin Tofel\'s About Chromebooks has spotted flags that turn on the feature by default for ChromeOS 116 and up. 116 is currently in beta and should be live in the stable channel sometime this month.\r\n\r\nThe project is called \"Lacros,\" which Google says stands for \"Linux And ChRome OS.\" This will split ChromeOS\'s Linux OS from the Chrome browser, allowing Google to update each one independently. Google documentation on the project says, \"On Chrome OS, the system UI (ash window manager, login screen, etc.) and the web browser are the same binary. Lacros separates this functionality into two binaries, henceforth known as ash-chrome (system UI) and lacros-chrome (web browser).\" Part of the project involves sprucing up the ChromeOS OS, and Google\'s docs say, \"Lacros can be imagined as \'Linux chrome with more Wayland support.\'\"\r\n\r\nPreviously ChromeOS was using a homemade graphics stack called \"Freon,\" but now with Wayland, it\'ll be on the new and normal desktop Linux graphics stack. Google\'s 2016 move to Freon was at a time when it could have moved from X11 (the old, normal desktop Linux graphics stock) directly to Wayland, but it decided to take this custom detour instead. Google says this represents \"more Wayland support\" because Wayland was previously used for Android and Linux apps, but now it\'ll be used for the native Chrome OS graphics, too.\r\n\r\nOn the browser side, ChromeOS would stop using the bespoke Chrome browser for ChromeOS and switch to the Chrome browser for Linux. The same browser you get on Ubuntu would now ship on ChromeOS. In the past, turning on Lacros in ChromeOS would show both Chrome browsers, the outgoing ChromeOS one and the new Linux one.\r\n\r\nLacros has been in development for around two years and can be enabled via a Chrome flag. Tofel says his 116 build no longer has that flag since it\'s the default now. Google hasn\'t officially confirmed this is happening, but so far, the code is headed that way.\r\n\r\nUsers probably won\'t notice anything, but the feature should make it easier to update Chrome OS and might even extend the lifetime of old ChromeOS devices. This should also let Google more directly roll out changes on ChromeOS. Currently, there can be a delay while Google does the extra build work for ChromeOS, so the standalone browsers get security fixes first.', '/images/blogs/chromebook-lid.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(7, NULL, 'Dealmaster: Back-to-school savings on tech, supplies, dorm essentials, and more', 'Whether you need storage boxes for your office or dorm room, or you want digital storage to archive files and photos, today\'s Dealmaster comes with savings to help you keep your life organized. From laptop deals for college to ergonomic chairs to get the task done; from school supplies and home essentials to robot vacuums and games, there should be something for everyone.\r\n\r\n\r\n    BIC Wite-Out Brand EZ Correct Correction Tape, 39.3 Feet, 10-Count Pack for $12 (was $26) at Amazon\r\n    BIC Round Stic Xtra Life Ballpoint Ink Pens, Medium Point (1.0 mm) 144-count for $10 (was $20) at Amazon\r\n    Pilot, FriXion Clicker Erasable Gel Pens, Fine Point 0.7 mm, Pack of 10 for $12 (was $21) at Amazon\r\n    BIC 4-Color Ballpoint Pen, Medium Point (1.0 mm), 3-Count for $6 (was $8) at Amazon\r\n    BIC Xtra-Smooth Mechanical Pencil, Medium Point (0.7 mm), 40-count for $7 (was $14) at Amazon\r\n    Five Star Spiral Notebook, 6 Pack, 1 Subject, College Ruled Paper for $18 (was $27) at Amazon\r\n    Oxford Filler Paper, 8-1/2x11-inch, College Rule, 3-Hole Punched, Loose-Leaf Paper for 3-Ring Binders, 500 Sheets Per Pack for $13 (was $15) at Amazon\r\n    PILOT FriXion ColorSticks Erasable Gel Ink Stick Pens, Fine Point, Assorted Color Inks, 16-Pack for $15 (was $29) at Amazon\r\n    PILOT FriXion Fineliner Erasable Marker Pens, Fine Point, Assorted Color Inks, 12-Pack for $10 (was $14) at Amazon\r\n    Signo 207 Retractable Gel Pens, 0.7 mm Medium Gel Pen, Assorted Colored Pens Bulk 8 Pack for $8 (was $19) at Amazon\r\n    uniball Gel Pens, 207 Signo Gel with 1.0 mm Bold Point, 12 Count, Black Pens for $9 (was $25) at Amazon\r\n    Oxford Composition Notebooks, Wide Ruled Paper, 100 Sheets, Black, 6 Pack for $9 (was $16) at Amazon\r\n    uniball Jetstream RT Retractable Ballpoint Pens with 0.7 mm Fine Point, Black, 3 Count for $7 (was $11) at Amazon\r\n    uniball Gel Pens, 207 Signo Gel with 0.5 mm Micro Point, 12 Count, Black for $9 (was $16) at Amazon\r\n    School Supplies Kit, Highlighters, Mechanical Pencils, Glue Sticks, Erasers, Permanent Markers, Gel Pens, Pencils, School Glue and more from Sharpie, Elmer’s, Paper Mate, & Expo, 38 Pieces for $21 (was $27) at Amazon\r\n    PILOT Precise V5 RT Refillable & Retractable Liquid Ink Rolling Ball Pens, Extra Fine Point (0.5 mm) Assorted Color Inks, 12-Pack for $14 (was $21) at Amazon\r\n    PILOT G2 Premium Gel Roller Pens, Fine Point 0.7 mm, Black, Pack of 8 for $10 (was $18) at Amazon\r\n    Paper Mate Mechanical Pencils, Write Bros. Comfort #2 Pencil with Comfort Grip, Great for Long Writing Tasks, 0.7 mm, 12 Count for $4 (was $7) at Amazon\r\n    PILOT G2 Limited Edition Harmony Ink Collection Retractable Gel Pens, 0.7 mm Fine Point, Assorted Ink, 10-Pack for $9 (was $17) at Amazon\r\n    PILOT Pen 26062 Precise V5 RT Refillable & Retractable Liquid Ink Rolling Ball Pens, Extra Fine Point (0.5 mm) Black Ink, 12-Pack for $18 (was $28) at Amazon\r\n    BIC Gel-ocity Retractable Quick Dry Gel Pen, Medium Point (0.7 mm), Black, Comfortable Full Grip, 4-Count for $4 (was $8) at Amazon\r\n    PILOT FriXion Clicker Erasable, Refillable & Retractable Gel Ink Pens, Fine Point, Assorted Color Inks, 7-Pack for $14 (was $17) at Amazon\r\n    PILOT G2 Premium Gel Roller Pens, Fine Point 0.7 mm, Black, Pack of 20 for $16 (was $28) at Amazon\r\n    rOtring 600 Mechanical Pencil, 0.5 mm, Black for $18 (was $30) at Amazon\r\n    Five Star Flex Refillable Notebook + Study App, College Ruled Paper, 1-1/2 Inch TechLock Rings, Pockets, Tabs and Dividers, 300 Sheet Capacity for $15 (was $17) at Amazon\r\n    Sharpie S-Gel, Gel Pens, Medium Point (0.7 mm), Black Ink Gel Pen, 12 Count for $8 (was $17) at Amazon\r\n    Sharpie Felt Tip Pens, Fine Point (0.4 mm), Black, 4 Count for $4 (was $12) at Amazon\r\n    Avery Durable View 3 Ring Binder, 1/2 Inch Slant Rings, 4 Black Binders for $15 (was $29) at Amazon\r\n    Compressed-Air-Duster-Air-Blower- 110000RPM Air Duster & Vacuum Cleaner 2 in 1 Keyboard Cleaner for $50 after coupon (was $100) at Amazon\r\n\r\n', '/images/blogs/generic-laptop.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(8, NULL, 'Raspberry Pi availability is visibly improving after years of shortages', 'Raspberry Pi CEO Eben Upton has been saying for months that 2023 would be a \"recovery year\" for Raspberry Pi supply—the single-board computer, once known for its easy availability and affordability, has been hit with supply shortages for years. Hundreds of thousands of Pi boards were still being manufactured every month, but many were going to commercial buyers rather than retailers and end users.\r\n\r\nMore recently, those manufacturing numbers have climbed from 400,000 monthly units to 600,000 to 800,000 to 1 million, a level that Upton says can be sustained \"for as long as is necessary to clear our remaining customer backlogs and return to free availability.\"\r\n\r\nWe\'re now seeing very early signs that supply is returning to normal, at least for some Pi models. UK-based Pi reseller Pimoroni announced today that it was lifting some purchase limitations on 2GB and 4GB Raspberry Pi 4 boards and Pi Zero W boards (not, apparently, the more recent Pi Zero 2 W). The rpilocator stock tracker account has also noted that its number of automated stock alerts has decreased recently \"because Pis are staying in stock longer,\" noting that Pimoroni and The Pi Hut had (and still have) multiple Pi 4 variants in stock.\r\n\r\nEven as stock returns to normal, we\'ll still be dealing with the aftereffects of the shortage for some time to come; the \"temporary\" price increase for the 2GB Pi 4 board still hasn\'t been reverted, and Upton\'s past comments have implied that the company has put off the development of the Pi 5 to allow stock of current models to return to normal (the Pi 4 was introduced just over four years ago). Other retailers still have purchasing restrictions in place. And some models and retailers will clearly recover more quickly than others.\r\n\r\nAs hobbyists wait for Pi supplies to return to normal, they\'ve turned to all kinds of other hardware to do the same kinds of work. Discarded corporate thin client PCs and old phones can both handle some of the lightweight tasks at which Pis commonly excel.\r\n\r\nBut those alternate devices don\'t work with the hardware and software projects made specifically for the Pi, including everything from NES-style retro-themed game console cases to Game Boy and BlackBerry-themed portable enclosures.', '/images/blogs/pis-at-the-factory.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(9, NULL, 'Western Digital HDD capacity hits 28TB as Seagate looks to 30TB and beyond', 'After a couple of decades of talk, Seagate announced earlier this year that it was shipping samples of huge 32TB hard drives using heat-assisted magnetic recording (HAMR). The new kind of drive technology uses lasers to heat disk platters during writing, making it possible to store more data on a disk without increasing its physical size.\r\n\r\nBut there\'s still a bit more capacity to be wrung out of older and more-proven recording technologies like perpendicular (or conventional) magnetic recording (PMR/CMR, often used interchangeably) and shingled magnetic recording (SMR); Western Digital announced this week that it\'s preparing to sample huge 28TB hard drives based on those technologies, a little over a year after announcing its first 26TB model.\r\n\r\nAccording to Tom\'s Hardware, WD uses energy-assisted perpendicular magnetic recording (ePMR) to fit up to 24TB of data on a single drive. SMR allows magnetic tracks to overlap slightly (like the shingles on a roof), allowing slightly more data to fit onto the same physical platters at the expense of write performance—this boosts the capacity of these drives to 28TB.\r\n\r\nDuring its most recent earnings call, Western Digital CEO David Goeckeler reiterated that 28TB wasn\'t the end for its ePMR and SMR-based hard drives. Past roadmaps have indicated that 30TB and 32TB SMR drives should also be possible, though these drives aren\'t ready for sampling to Western Digital\'s customers yet.\r\n\r\nWestern Digital is working on HAMR-capable drives, too, but the company doesn\'t think they\'ll be available in volume until late 2025 at the earliest. Seagate expects to ship its first 32TB HAMR drives before then, and the company has already talked about HAMR drives as large as 50TB being tested in its labs.\r\n\r\nWestern Digital\'s earnings are buffeted by some of the same forces affecting other PC hardware and software companies like Intel and Microsoft. The company\'s earnings for Q4 2023 were down 5 percent year over year, mostly driven by an 18 percent drop in revenue for its cloud business. Its client and consumer businesses—drives sold to PC makers and directly to consumers—grew slightly. This time last year, all three divisions were down by double digits compared to 2022, so the post-pandemic PC slump could be bottoming out.', '/images/blogs/western-digtal-hdds.jpg', '2023-08-12 19:45:25', '2023-08-12 19:45:25'),
(10, NULL, 'Microsoft keeps pushing toward repairability, now with Xbox controller parts', 'If you\'re the type of person who hates the idea of giving Microsoft another $65 for a new controller (or more than $100 for an Elite Series 2) because you know there\'s just one part broken, Microsoft has a store for you. It\'s small, but it\'s something.\r\n\r\nDirect from Microsoft, you can now buy a half-dozen Xbox repair and replacement parts for both the Xbox Elite Wireless Controller Series 2 and the standard Xbox Wireless Controller. Each controller has top cases and button replacement sets in black and white, plus the two inner circuit boards that provide charging, input, vibration, and, of course, sockets with new potentiometers installed to fix stick drift.\r\n\r\nParts on their own aren\'t that helpful to most of us, though, so Microsoft is also providing written and video guides. The videos are essentially full teardowns of each controller. The Elite Series 2 requires a plastic pry tool (aka spudger), a T6 and T8 screwdriver, and tweezers. The videos are helpful and aimed at all skill levels. \"Always push away from yourself when using pry tools, so if you slip you won\'t harm yourself\" is advice I have refused to accept a number of times.\r\nMicrosoft\'s instructional video on repairing the Xbox Elite Wireless Controller Series 2.\r\n\r\nAt $35, the drift-fixing \"Replacement PCBA and Motor Assembly\" (i.e., controller sub-board, or \"daughterboard\") for the standard Wireless Controller is certainly cheaper than buying a whole new controller, but it\'s also a job requiring some wire-running patience. Repair store iFixit sells most of the same parts, including some individual components, like joystick modules, for those with a solder iron and the will to use it. iFixit\'s stock is less certain (they\'re currently out of controller sub-boards), but they offer a lifetime guarantee on many parts.\r\n\r\nMicrosoft\'s offering of official parts follows its agreement to expand parts and repair options after a 2021 agreement with activist shareholders. Since then, the company has posted its own teardown and repair videos for Surface Laptops and started selling parts for Surface devices. The company\'s pivot to offer more at-home service options also comes a few years after it closed its retail stores.\r\n\r\nDisclosure: Kevin Purdy previously worked for iFixit. He has no financial involvement with the company.', '/images/blogs/xbox-controller-repair.png', '2023-08-12 19:45:25', '2023-08-12 19:45:25');

-- --------------------------------------------------------

--
-- Table structure for table `blog_comment`
--

CREATE TABLE `blog_comment` (
  `id` int(11) NOT NULL,
  `blog_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('BUYING','ORDERED','SHIPPING','DELIVERED','REJECTED') NOT NULL DEFAULT 'BUYING',
  `ship_address` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `ordered_at` timestamp NULL DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_item`
--

CREATE TABLE `cart_item` (
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Triggers `cart_item`
--
DELIMITER $$
CREATE TRIGGER `cart_item_insert_trigger` BEFORE INSERT ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = NEW.quantity * pprice;
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_item_update_trigger` BEFORE UPDATE ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = pprice * NEW.quantity; 
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_total_price_delete_trigger` AFTER DELETE ON `cart_item` FOR EACH ROW BEGIN
			CALL change_cart_total_price ( OLD.cart_id );
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_total_price_insert_trigger` AFTER INSERT ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_total_price_update_trigger` AFTER UPDATE ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
		
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart_promotion`
--

CREATE TABLE `cart_promotion` (
  `cart_id` int(11) NOT NULL,
  `promotion_code` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`) VALUES
(1, 'Laptops'),
(4, 'Microcontrollers'),
(2, 'Phones'),
(3, 'Tablets');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `image_url` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `short_description` text NOT NULL,
  `specs` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `image_url`, `quantity`, `short_description`, `specs`) VALUES
(1, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) l13-2242#az', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nRyzen™ 7 7840U • 16GB memory • 500GB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 16GB (2 x 8GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"Radeon™ 700M Graphics\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"55Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(2, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) l13-3472#de', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\nRyzen™ 7 7840U • 16GB memory • 1TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 16GB (2 x 8GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"Radeon™ 700M Graphics\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"55Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(7, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) l13-2387#de', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\nRyzen™ 7 7840U • 32GB memory • 1TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 32GB (2 x 16GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"Radeon™ 700M Graphics\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"61Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(8, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) l13-9238#eg', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nRyzen™ 7 7840U • 32GB memory • 2TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 32GB (2 x 16GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"Radeon™ 700M Graphics\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"61Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(9, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) l13-9782#ef', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nRyzen™ 7 7840U • 64GB memory • 4TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"Radeon™ 700M Graphics\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"61Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(10, 'DEDSEC Laptop 13 (13th Gen ENTEL® Core™) l13-2383#ef', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nENTEL® Core™ i7-1360P • 16GB memory • 500GB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 16GB (2 x 8GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"ENTEL® Iris™ XP\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"55Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(11, 'DEDSEC Laptop 13 (13th Gen ENTEL® Core™) l13-9323#ef', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nENTEL® Core™ i7-1360P • 16GB memory • 1TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 16GB (2 x 8GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"ENTEL® Iris™ XP\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"55Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(12, 'DEDSEC Laptop 13 (13th Gen ENTEL® Core™) l13-2424#cd', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nENTEL® Core™ i7-1370P • 32GB memory • 1TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 32GB (2 x 16GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"ENTEL® Iris™ XP\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"61Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(13, 'DEDSEC Laptop 13 (13th Gen ENTEL® Core™) l13-7621#cd', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nENTEL® Core™ i7-1370P • 32GB memory • 2TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 32GB (2 x 16GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"ENTEL® Iris™ XP\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"61Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}'),
(14, 'DEDSEC Laptop 13 (13th Gen ENTEL® Core™) l13-7121#cd', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/dedsec-laptop-13.png', 0, 'Extremely modular design with upgradable components\r\nENTEL® Core™ i7-1370P • 64GB memory • 4TB SSD • 13.5\" display • Michealsoft Bimbows 11 Pro • English (International)\r\n1.3kg, 15.85mm thin ', '{\r\n   \"Processor options\": \r\n   \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ,\r\n   \"Memory options\": \r\n   \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ,\r\n   \"Storage options\": \r\n   \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ,\r\n   \"Graphics\": \r\n   \"ENTEL® Iris™ XP\"\r\n   ,\r\n   \"Display\": [\r\n   \"13.5” 3:2 2256*1504px \",\r\n   \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n   \"Matte\"\r\n   ],\r\n   \"Battery\":  \r\n   \"61Wh\"\r\n   ,\r\n   \"Operating system\": \r\n   \"Michaelsoft Binbows 11 Pro\"\r\n}');

--
-- Triggers `product`
--
DELIMITER $$
CREATE TRIGGER `product_update_trigger` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
		DECLARE `done` BOOL DEFAULT FALSE;
		DECLARE `cid` INT;
		DECLARE `cur1` CURSOR FOR 
            SELECT ci.cart_id 
            FROM `cart_item` ci 
		    WHERE ci.product_id = NEW.id;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

		OPEN `cur1`;
		`cart_item_loop` :	LOOP
			IF `done` THEN
				LEAVE `cart_item_loop`;
			END IF;

			FETCH `cur1` INTO `cid`;
			CALL change_cart_item_price ( cid, NEW.id );
			CALL change_cart_total_price ( cid );
			
		END LOOP `cart_item_loop`;
		CLOSE `cur1`;
		
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_comment`
--

CREATE TABLE `product_comment` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_rating`
--

CREATE TABLE `product_rating` (
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `rating` decimal(3,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE `promotion` (
  `code` varchar(20) NOT NULL,
  `discount` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('INACTIVE','ACTIVE','EXPIRE') DEFAULT 'INACTIVE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `role`) VALUES
(2, 'lorem@ipsum.com', '$2y$10$WFBGCzMjm3LmDNM.zVrZz.qudis0cgIZFykSiI9rA8nxtIz6CbDCS', 'ADMIN');

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`id`, `name`, `image_url`, `birth_date`, `phone`, `address`) VALUES
(2, 'daniel', '', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blog`
--
ALTER TABLE `blog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`author_id`);

--
-- Indexes for table `blog_comment`
--
ALTER TABLE `blog_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `blog_id` (`blog_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `cart_promotion`
--
ALTER TABLE `cart_promotion`
  ADD PRIMARY KEY (`cart_id`,`promotion_code`),
  ADD KEY `promotion_code` (`promotion_code`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_name_unique` (`name`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_name_unique` (`name`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`product_id`,`category_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_comment`
--
ALTER TABLE `product_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `product_rating`
--
ALTER TABLE `product_rating`
  ADD PRIMARY KEY (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_email_unique` (`email`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blog`
--
ALTER TABLE `blog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `blog_comment`
--
ALTER TABLE `blog_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `product_comment`
--
ALTER TABLE `product_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blog`
--
ALTER TABLE `blog`
  ADD CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user_info` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_info`
--
ALTER TABLE `user_info`
  ADD CONSTRAINT `user_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `update_promotion_status` ON SCHEDULE EVERY 1 DAY STARTS '2023-08-05 09:37:45' ON COMPLETION NOT PRESERVE ENABLE DO CALL set_promotion_status ()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

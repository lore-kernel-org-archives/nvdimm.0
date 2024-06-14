Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B81C2107;
	Fri, 14 Jun 2024 00:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326681; cv=fail; b=OE+1/oJYqdm8q5csAs9OH7QfLX7BXm+dFSVIkdl4ObGDCxID1POak4/qiLmr1Iv98MwANNMW6g8emITG+8xj4IdC54Uhm7n/zjtiQ3q5AssMwkjoFv33CFeqxeAeR0etKn4rxxGnOk91QWElLrvG9YHQehKjqVKZIQigilfB2vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326681; c=relaxed/simple;
	bh=rAaCpEIXBmA7PGkuBKCW+8kL1Wb4LvNYsGsbcIn6DnI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ssl91tu9rD2Pj+5MzyAvb9IYim+td1GchdVvviwELaxniHskugJOLCsTN8oSd0+OxsrW6fyAc8KKegV8QUYlo/OLKiFwLSjCu3u12KI27xzm7s4CQAXkDsESNbOMhaFSFHxPdWF0mvNNSW19Tdffhho0Ly6Y3Cuddgw4sM7hlVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YzQzQ7W4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XR/oHx3f; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YzQzQ7W4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XR/oHx3f"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DEtTrd003173;
	Fri, 14 Jun 2024 00:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=q1dmVd5XXIGU4Y
	gl2p7qC291juJzGvbEJG5VmDC1L44=; b=YzQzQ7W48xO8dKimPMK88kubzXQVfX
	YslJ33MM+ZEBYD0/tsy/EiTB8fn164c305oOCdT/xAIZjPOS5YsogpzKjEygwrI4
	HxgvFAvFVE3BUqKPPdQZEYbzaJUMqVAHdiV5viWKis2jETcqMGsmO6THu54/Desl
	O455j4CnQDIS6e4heljtoO3UiFAH072OYLEuOQ7s0InuX3WGSqaaASmFvZTW2LEZ
	+ki7PdnPYZQ+mjqTa5+HG3G2SaxVyb9vByxnMojIPhwpZtgZvQST0qCzLeX3+dft
	uK4i5dG3Ng0sRpKtwPGGKIGlAtGrNSvSlcSVEGA6M5dx5XkKRipepTaQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1jqkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 00:57:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E09nqI012495;
	Fri, 14 Jun 2024 00:57:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1tqvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 00:57:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrYKrJ8MAomed5GMMjspxGaIwimlqj5i7UQ0JzP5PZQO5ZUQQO/HyV7BoavvE/nuProta27HU9GKvl3ZEil5DDezbgi24tevDP2oLwUiwapaLg0mdWzJITwXKNJXZuxH5hY/FyVF2pdQOrGAgrfer2SOR6ypfxtVD+f8bzsCNy1tr0n76p+Ahu3VSF+1i7qqvWgkIfgz9f9ZPI5lABdLEoBzbjkQjwYX7iDpMgrkiPEwBDKY0gmgUE39g/As/BlPjWX7afj3cIOT0HIXR2wVAh1VOZBkMcnKFFWh11W2CVos7cajhAFLJJ/mEQmTJFTk2MwY5+oNabpI5BztcCFgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1dmVd5XXIGU4Ygl2p7qC291juJzGvbEJG5VmDC1L44=;
 b=cYSYmkcMOiYHTWc+ER2ieXP1UHTY3wVuge51KsQYoQfjckInt8FDeLDNFJRC0UjGLTcw/3tlWKpY7cBc9ZdbxLGyoIlnEB5JY6p9o6Bo8YFS7E5Jbv8bo5FxyVKJpulR7SGbR2GQwazZo+0hRgfktG+nyaTNF445dFQ0WOUxtUfUjEYOSEV3M497IL9KgqFPeTSAHmoxLCnPIWMe/B7kmuQegzNTIqyb5uI9eXn0f7Ky1UicVaLNr4xyvv0VCWUqMLuL4wsYDdO0uMwUtIdgHYgK4FvjqMOTm2UQkl/wP4HNHes6VacBvNJ8gEVaxItWvxYPP0gfbaZndewH3a2/Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1dmVd5XXIGU4Ygl2p7qC291juJzGvbEJG5VmDC1L44=;
 b=XR/oHx3fObnE67cWakZReco2ctTEcYwSJvcJiT81fTKNgPGALonsmf0vywA8TYphnz3LqE8Z6hnx+idvhQ0Y9/KWKILJTHsBVgNuZY1OdL+PTXdTuIPlENHUpwsm3dukE+S545USOYjl4PlVR9Q40hPGd5w3EEva1a7wlqsuzws=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB6095.namprd10.prod.outlook.com (2603:10b6:930:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Fri, 14 Jun
 2024 00:57:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 00:57:28 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe
 <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka
 <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu Kuai
 <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
        Vishal
 Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira
 Weiny <ira.weiny@intel.com>,
        Keith Busch <kbusch@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 03/11] block: remove the BIP_IP_CHECKSUM flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240613053528.GA17839@lst.de> (Christoph Hellwig's message of
	"Thu, 13 Jun 2024 07:35:29 +0200")
Organization: Oracle Corporation
Message-ID: <yq134pguyv0.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-4-hch@lst.de>
	<yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com> <20240610115732.GA19790@lst.de>
	<yq1bk492dv3.fsf@ca-mkp.ca.oracle.com> <20240610122423.GB21513@lst.de>
	<yq1zfrrz2hj.fsf@ca-mkp.ca.oracle.com> <20240612035122.GA25733@lst.de>
	<yq1tthyw1jr.fsf@ca-mkp.ca.oracle.com> <20240613053528.GA17839@lst.de>
Date: Thu, 13 Jun 2024 20:57:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0008.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY5PR10MB6095:EE_
X-MS-Office365-Filtering-Correlation-Id: 4639a80e-d653-41a8-cc4e-08dc8c0cf644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|7416009|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?UpJ5/ei6R9STK/fvyxLznctF5WiZis1gMwTy8cRpwSBDH8snvgwwrKnD7aer?=
 =?us-ascii?Q?6z3pjLguAkE/0biMjs+QcR3rfg+4t7hiFqU07f5j3G9WnNoXuMx5/nuQjw7x?=
 =?us-ascii?Q?Yj+1pOBb5pOb0x9WvfIZY52GbxN2LWWsY5LP9c7tAavUjCj+TApzU3XEW8FF?=
 =?us-ascii?Q?ShqpTy4FK9oXH9lqBREvztckc+m/OmO4BgMm4fcJNbQTyzdN9ByJgJOSGgpB?=
 =?us-ascii?Q?tC8hSbuSsr/qkb4qlSE6ZraYvucX4/1fiBG3ybak/ZkHLgzcvDSbqXXVwaSK?=
 =?us-ascii?Q?ZBQ7q+XbPLWa+16lVjYSlmJjAmhxa50W6+ptcbRHOPz1pnaw1fgM8BMbdZDh?=
 =?us-ascii?Q?6yiywpV8RXBodj1xTszbjD/iyChlFB1a4DVxvDkDZT290iRtx+Sy0mvDfh7u?=
 =?us-ascii?Q?4Lq8zPHMciiRysLrXA6LcjdCLOvucULwDeP167govnJ0JCNxhTjka7+N15/u?=
 =?us-ascii?Q?bsO/I2aSnGRoQNTkz75b7GrdwaJuwuuMx5mn6yJEwF/nDon5tBlbOF+SkD5I?=
 =?us-ascii?Q?uTTQi+k3qr2xGkDLLxblRPXleYt53+ook8PzQ3t1bgikgRymc057zRnGYYXc?=
 =?us-ascii?Q?frqfyAjQBVuyLlMCJcdlR1Owml4danFPcgW2Y65GUwL7tyHGe6z+693kcxbu?=
 =?us-ascii?Q?d3DO/xSo00G/37v3H9F74cynZjLOGZu3rLS8JLHPtFnXPmsNdrXMjK+zuiQ4?=
 =?us-ascii?Q?AXRzYtjRudzHdEQL5jsZfaZZ8GFGO7HuMGjKfssrGlirF/9PzifcKYlhnH3/?=
 =?us-ascii?Q?ZAMdRJtY6FSa/Px5ai1HENPeEMdJgFcOFO/hMhjbKeqmDlw+KJqbUww/srmZ?=
 =?us-ascii?Q?gCR/LMZDZTo7byvxFMU/5Jzm/ylDrk9uAK21U+YPsdk4i3yp7cuftfS7txbA?=
 =?us-ascii?Q?q1AXxtvnugU5+BAcIN8jaBk2K42lFHORES4KCpGYak8ylhbloC5NBmQSRClD?=
 =?us-ascii?Q?FpGczVVtID1MdwKtcrZrRXthyce3WuQpgoVqg8eQis4fB1XRjZBe5U8X3D2W?=
 =?us-ascii?Q?qPBmq6VQpXcZTwLaP9xlNcs4kmjynvhgafYyCLE0rFTSP1/DEKG2P4ZeqUsr?=
 =?us-ascii?Q?HTFFcDIdxBZhPAnJ/o6CvbshI8jVstOofIQc/ISzb4JVENtdKE9guL+hlvc2?=
 =?us-ascii?Q?190c3EfjrEg1vVobEUr9ZF3yFPZ2lrHfaXyNlH1l5RLV/iw36dKopsEtbQ02?=
 =?us-ascii?Q?FpyCREYWWJSe+pyXMx7Ju6SRKltDIZLVrFzBZMXW3IlEGs1HuuZTbpbd/uRz?=
 =?us-ascii?Q?Vl0OQGbFWMJ8ty8xbROadV2M6fa4w0YctD2PrcbnCYqOgJe+j4ATLmE9uh45?=
 =?us-ascii?Q?2iGkPq0vD/yw0uw/VD9/9eda?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(7416009)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5Pp6iUXKSs3dg8GkxI68tmx97ZbfmmiEvBh7cPYS4KZ2hX8TPsJaN5FtHhVu?=
 =?us-ascii?Q?DG0rTUfBmX0BNg1UeMjN+jf9+DbMHaQ2kASlkZotL8oL5Dfeh47nd3Tj4czQ?=
 =?us-ascii?Q?kwBsnKAKCb34oK5oSEgEdnNwhOBlRoqy1tUUhmveTiqJiMUFBiykz3HfVYiF?=
 =?us-ascii?Q?J7n1coCsuo8mlrZBdV3i2i5b5/8eonu8CRzTVJaItLk1WAzhkGEKVvbVau1n?=
 =?us-ascii?Q?lyz4DapCN3mTEjn77Q3l6ENt9pfOozmyLHT1Q4ij6aEBz1XwcGbtiWHzsYk6?=
 =?us-ascii?Q?4OBX/K5uNvSg/vXpa4dSN/+H/PWm1NSP+Ltzx+ila6d1Fhp/EBJ2iJugOXtU?=
 =?us-ascii?Q?mF5t7e6SgxHs0zdVC53UTpcIi01F954keGmu9KufeLAUIQoQxl+Svleb5o1L?=
 =?us-ascii?Q?RZ8C46BD2khYUkhKe2gB/zY57XCi7UPVjog1khVWwzPDah4waF9Fn5lrTZM9?=
 =?us-ascii?Q?PvVlvDUpx+h3zGdq7OqYtmxxaM12i08KTberw8vZghgIQvD/fxEaMagaCY37?=
 =?us-ascii?Q?SFA2MC9i8aip9LadIgaKugPbDX7ht7Bt0lQElrAvIjZuvhSc1xkrqAu6KDVc?=
 =?us-ascii?Q?ze0OItIxDbxyKORexpfXCuDKxy3GrIH50Q8P7QfiLbOAKpXLl7w3xxYDunEs?=
 =?us-ascii?Q?gAU81Cil7CgaYu+muib4naw1HLgJ6oP/fr+IZdTCWTdQGP9sbdiHjfu9tEaG?=
 =?us-ascii?Q?QyQHVQ11eEfFa+803A1vgURS4pxHO/QxBzFiOEqGoiBUGx1wWZ0pQsDm40TN?=
 =?us-ascii?Q?SghC40r2Pj1Uu7tnKUXiN8tv9XfHjfjLVh+Zmfhnz9af89STlg+j99AXO9lo?=
 =?us-ascii?Q?BZ/fk4ibG6lvaHR/MiEMyCisvfkdhMUE7opSynkQxy4AFbZgY7Wo54pqLvN9?=
 =?us-ascii?Q?UxHCN0yy1d1Yp0mHIJSDBBM9c/uigWXwluOeH4hf9VU/EsvcQkHInzbEau8c?=
 =?us-ascii?Q?+/DPfTEpyr0ldlELMyYItrp9Lzg6u9r5J3v75YdMXyFlNiTcxDTF4KpxxVYE?=
 =?us-ascii?Q?3l2XUe/u1hMCi7BP712nKx2KC2pYtmRN7BMuqOKH11j54R3lwPTbygkX6F3C?=
 =?us-ascii?Q?1Su5StIc5Rdpje2Ny4MSud7Hd37kSv+9HyuklrmnUyaemJPlQttUXu6hXaC+?=
 =?us-ascii?Q?2+XXfgqOmc/hzBgiNH+Hjy9L31lOXEYL2SFKfJuYS1KAdkVZjtVUiJkRF0d2?=
 =?us-ascii?Q?5/e//1x/Ntp6dxIkLS8UFiZLgS5df+x8dPt/XqaGo0sJI6Qc645JyJozCvJD?=
 =?us-ascii?Q?oqFdAShLlQX0LzdNt6AVr6ZHhW9hf5GV68/qgK5IRe1brbkCZ3dOG0AZHzd8?=
 =?us-ascii?Q?EFOeZuDuEINNjMYzoAUp/Qb353+b4aTNhAQyNM1eMn5c5xgxgm0zFBOLbnAC?=
 =?us-ascii?Q?8hUJhkdUnj5nJIX2qHwb9xHZ/K7dBAoJmFApWMHY4CgF7EdNwG+z+YLA+nOc?=
 =?us-ascii?Q?Il2gRpM46w4dMZFGl7gvARe+0s9fymXlFBickrAKdcb3gX8EqtFnt7aT084O?=
 =?us-ascii?Q?mmFYiP0sOOkPTFLezZ8b7MxBx/wyXJ2LGU/0QitHmkB1TaGOI4T8BHyetGN0?=
 =?us-ascii?Q?co/f+xjPKtP4t9CAMJfTpMiRvvM1fkToGy+5Ci3MfvGx98TPKutjX6uIZFNW?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	c8+RQBHi3e48A0/n6JmKe72Z/VS9SK87JizVyMvqTk+zDLhjZUkwgisuc2GBwpGSxTzH543XmRKJkZ8TlINVD3nepORz38Xfbt+BMFi1UH7BSFVBkpzLswYkH7JGeIbMlHlKlbUhDe0+/yXcDgVwtgyaVFXJLSw+hjf30f91qoXY5gjyC0rulpWmKtfIsRiiO0tdy3osnEhsUJKCLuazTBtRdj+/2HvPfmp8TR6X+Qc8ce07t8428Pg3f/8sE1mDdeNAGv0Lz8n7Inn5oRqRG0s2hh+Zy1sBtkTnIRxqU7BUsUzUnj9UzvRQvEM45vAyNnRNPTWIcmYS4f1SIhJJHbWave3WhzP/JE71nthfLOMNvBa7F60962vwVWK6j6DJDoIfKXHGhLWy+d5fKkfKw0IH/FUVKD7xTkYhkYCKrLhQQcwKmo9gnkPfW1j8KA5QNy8W8lA/SJ+YE+ObFS9FoMzOynC/02twAdEGZ+5kzTv0wg5qhGG3hBJHQZi71SIiHfd6JM4yc27i0Lm6mPyCGuvIGb2bUVJwdUKeuH3K7U8n2xH/KYvHvlOUEQKM7aZA9b26RqfLqmiqqzhyKSVzPSzPvsq4CYQr2EhgVyYNPls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4639a80e-d653-41a8-cc4e-08dc8c0cf644
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 00:57:28.0818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +P18/KGRjH3x9wpY9MrgCKx60wJiPu8ebca22x0Glu5lLaJa2ygHOsGMUFI3eNHFXJUpgX7qDEiCVb1JP1HxOcKQrStcsIMe/Xl1muL5cAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=941 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140002
X-Proofpoint-ORIG-GUID: fREaZBQ6O5SwJnUNzbHpdt16LUmPrkwp
X-Proofpoint-GUID: fREaZBQ6O5SwJnUNzbHpdt16LUmPrkwp


Christoph,

> The checksum type?  How is that compatible with nvme?

NVMe does not support IP checksum.

-- 
Martin K. Petersen	Oracle Linux Engineering

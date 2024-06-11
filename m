Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA7E13DDA7;
	Tue, 11 Jun 2024 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718135522; cv=fail; b=diCr5t49KEZ9OkZ1HgJm00GweLtEHxfJR6JSkZ/pdRB3ONRlnlnq13Wzcct4i/IjrfVy40n1IPCd1R8X6/tfG5P4QvSm9keO/xSsVNAwZLqlVusfGxnoQ2UVPX94ZGLuG7AM65i0i4UdfVs3ymyfFeat1OuvkYsS8B203bCUGN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718135522; c=relaxed/simple;
	bh=+M3tbDuyDDbIi1zbPGlHrf6Fa1waf+Q6U740+8w24aI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VF6f9xSz7fYLVIbwACVy/zQDjWz6NVgHxp5drk39e2gTGyGJ6jNbOAjAuvlM/PzXjazW2ALCEogTb74pvF2DhCFi91tX4LpF5DhzUah/JoGuhietmo3zEohb9u69wNvtW/4LtW/0WaxNfTPSvqn0bP+Gpvc+xJ38kx8JgEVahc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NV/n8pK3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I8oohIoC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NV/n8pK3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I8oohIoC"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BFZ7FH026886;
	Tue, 11 Jun 2024 19:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=lPvU73ziChYWfZ
	5SHEhGJ3hH2APFUvJRl6qju5uuWTw=; b=NV/n8pK3x982WhKLnHD5p0weDXLL2G
	3ARJOCPgTMORIkbd0Fzu+eLtnmAROjJB/l4JGU9wsVTjL+dtdtK6aIMT6iKkavHT
	wiBhqJpmMqcxp2xhwGhera/8NA+kZGDTxcT4FPisDEKnS9bGXqhrdombO1qcetNB
	B5RLCVO4+SUhBN4EIcSq/b6ygqQQT15g76wg3GI+ODQMotI6gBXsArAVNbkSyqfV
	clb/RpX5nHnGVI83K02hWzlEVNxusMggB6kG4tcM4bHZsRr1i2CNixpP3xdy4fs9
	E28cBrJG26LCg1i19dznLRqa3QnHvHVcPCgLAjsDxoAhsIFFoPHcyxGA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1gdqq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 19:51:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45BIAaFd021160;
	Tue, 11 Jun 2024 19:51:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncav05uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 19:51:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCu3etdtpxIns5wKGpb2rZ0kUVaP8WKlfnwNh3WR1l14+XpysJ8rM7ItSwnXNzQzehiXVmxREoPBX5a6mCEY6kmi+x1af9K/d58y4h6otSeFRly6L1yVU76A3VOeptaL6SWi1SqA808JlXOKUWkKtsk90FGiEZiPab9cuqgiqeZUOXMFEX0MwfM3PH8LeJ89aK2PoRwamxkJjB35CSACosjBM3HL/2ZR+ZWfAgn6hs3u50IWi3MrUAGa7f7EZT/GpmNUgtXK4O8oF2C2sEuE4ds+EVrhLn/yTG66LbJc2911UqB/MeZ33+Vr1+rHxlqKICazbRx+dX6qajY29eosIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPvU73ziChYWfZ5SHEhGJ3hH2APFUvJRl6qju5uuWTw=;
 b=FLJ+ljKCC/7l7ot4lMDs8LnIAoxdhww5XT8j1fVYP48zwiBoW+SPwy3mszzZAUEAATbOayV7XwxIU9arrtOpdaJB0xjtupugRRgWj52Dv0AG4xSiHcvYpqbeP+c9a1LAzLdpES4j7Gi+8l3SiWAiH3XnW21vK4L2d2Loeaf6zUV5iAEYOZncyciUoeh9RAH7TYwoLQClkEpw8TiD2lH0vZ/QFvewnyvZxCr3sEOGCaxxPK9QY4dKfPIxYYfX55AymUsKgaF5sfxdBhn9TL5/MBfl6ML8bak/8F+m20pFhQJC9DwbhuozeGlxvrRsLcz6ALtDd40vpTA5AEvTWFzNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPvU73ziChYWfZ5SHEhGJ3hH2APFUvJRl6qju5uuWTw=;
 b=I8oohIoC3no/Gjuc9nnELQSk2IjXBQKCs2j12mvcs0Ux+KhaBoReY+X0mjZRCuM0JYv21zwlffrVsZQNHWnwz4sNti8JfDVdjggQ8KNwH8BWqCAY8SogmZz3I4AqmAFSTJV7EgJFauBEwKoTlW7hJsh+R2otsJQs1h22al7VM8E=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BLAPR10MB4947.namprd10.prod.outlook.com (2603:10b6:208:326::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Tue, 11 Jun
 2024 19:51:30 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a%3]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 19:51:29 +0000
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
In-Reply-To: <20240610122423.GB21513@lst.de> (Christoph Hellwig's message of
	"Mon, 10 Jun 2024 14:24:23 +0200")
Organization: Oracle Corporation
Message-ID: <yq1zfrrz2hj.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-4-hch@lst.de>
	<yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com> <20240610115732.GA19790@lst.de>
	<yq1bk492dv3.fsf@ca-mkp.ca.oracle.com> <20240610122423.GB21513@lst.de>
Date: Tue, 11 Jun 2024 15:51:27 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:208:134::46) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BLAPR10MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa783e0-527b-446c-0240-08dc8a4fe30c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|7416006|376006;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?gnFvMLBKZ1bl1N4UhqTThm5h5sx3sKv485MTBmRpWxsrI5lwHOjeqZjRVtdO?=
 =?us-ascii?Q?ld1MidODB+YQByU+PmUrY7w8BLW1YBuVoKR7Td1r6lqVL2R7H+DnnBH0D5hg?=
 =?us-ascii?Q?nlsjEEhaTdxTEHGRImBKxeih4hvOtBRjuMUi24gJf3ytNfNGNCnN1aCxteMJ?=
 =?us-ascii?Q?j98hFN9tMyHL57BkX1UiOwfpWBMHHM8ME1lDjp0C2UxxSWe77SqwzuIL5IXe?=
 =?us-ascii?Q?YDDxkcrOyLKRu/3xTDWNSAqrUGtq4yGe1YY+qVmd40Xo8e2v/KRn5CV4slSA?=
 =?us-ascii?Q?Ut1bFN7Id4rcvL1/8kY4+/ilOYsyodYXCNoIdrutq9E3p7MJzs3NdaXZ6P6I?=
 =?us-ascii?Q?BbXNYhWTZ3vpATEzvzBuJPgaiVW/OtPdes8I5gztXTnjZFUAyGJMQyIlntkf?=
 =?us-ascii?Q?7s6uadAm2s1s6GnStZpcexSyJ7aYbYkHzvmiFlmysQBgA7hN1c2oThku4nkn?=
 =?us-ascii?Q?X6mfnRr0tLlD9RUtXqBjfSNH7oOnjzGviy2RFQtT9FLz98yi8lx8B9ZM9IcV?=
 =?us-ascii?Q?HKVnYv4VVxlbgVndkiBRNaK6AXAbdoZlDt3G09/NWsFnhftJ4BrYlpIsho56?=
 =?us-ascii?Q?AmPHbIx2vu2fFEjbanqaPE9KEhdf6nPVKgzmP/iunp8PwtKBvkhsU7bpuMgJ?=
 =?us-ascii?Q?ROPdkw3lqPrySSRlh8Pear3Ci2wQ4kiClrLnDUYuemfuYojwFL5IzdgTvuoF?=
 =?us-ascii?Q?Yv9E55ZHEfFmOFjYfNQy3jilUGlXZ0R0w2pmwUEUJtoBOnvXu53M9qvKwoHj?=
 =?us-ascii?Q?/M+9pfBEUVkZ+jQtp+Auv9boUynu/JUYrRLWvTupP74TbznUuXxQrCk4kvPN?=
 =?us-ascii?Q?BktN4CHjwk+eZRICijkTYc07Whvv/6td7TNwpf/7HM/ym1HCZNylfDkWNjdl?=
 =?us-ascii?Q?0HqJ2G9S/GG3mVpvp71arsiz+kKWChtQqm2SSnGUWBzJdyg4DMQPPZP52sw8?=
 =?us-ascii?Q?9eclhRfn4wyw1hWiSa1t8SJo3S/wuT+yOkTvt1Nr5H/6Kujl6LSfHFbZ84XW?=
 =?us-ascii?Q?o7dMIwj9z7a2ULQ/0tIvdpTAMRlm2DzMfWbHx5JZmvkwgpYt4ZXznro7PteK?=
 =?us-ascii?Q?YOr1eC2qZKz4xpB+VbkHhq0fF9dGt0YNy3MAA/AUTIp4eok40BR1Vj9B7msx?=
 =?us-ascii?Q?troF+zhasZWrt0BOitaNbGg9zBSbpY5s2rpNPKmHrY1OiLBFPnqO7zZoilmw?=
 =?us-ascii?Q?uRb4HMte0/UwYabGqvTAvhyDzlDZi7nH7rysxe9Oc6tT4nC8zkFuckMxI9qd?=
 =?us-ascii?Q?EYg7b14oeAl7FvreWyp3e8m6BvvVp754iMfAosHvlViHEp66DXs6qaPGkgOD?=
 =?us-ascii?Q?BTI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(7416006)(376006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0cHrGKSFa8At5q7aJ+CQFjD27bjnoWr4sKPaOrK/8NDUeOrZHafiw90XXne0?=
 =?us-ascii?Q?xRCYj3Ho+m9PGd+cO41uficNhwTEoEo7NkhRqNC/fN5H6rH5EJ2F/Tza75Qm?=
 =?us-ascii?Q?Sk1nd/dYkyLa+uUwI7ykE6Cgx8rAnpxfg7sZVxpp7xhP8l5UKKJY1Rqrtgta?=
 =?us-ascii?Q?SypYgLq6NWo0qX6q8mSMFxNhiT04BwXhLdN+4DsPSeEo3GIAlKFwyK5jYONW?=
 =?us-ascii?Q?vp97TEkI/1LmE2QW7LOB2PTEkGozaUnz59a/+xKgBNyCFWYwRyVsAxW77R9/?=
 =?us-ascii?Q?lcPi4drpEHmzGQJVvb6yo6OeQ+MqDXGcU5pD8tgQpDSa92tc4qMKF+cCk2Xf?=
 =?us-ascii?Q?pk/DVKww8lWorAeXHJDOjIO7SFMta5/Jv5fVXO3aulYLghq7/2uNFzU0qQFM?=
 =?us-ascii?Q?7G8nAp+thXMsxf2tPrF8CTUaMYfyKLoTPajFBaSTRPZLfFyAeoqdacsHz+SF?=
 =?us-ascii?Q?3aRVPBCjP7+btpDFERO0OHL6UaIV644pvQviROC9YarP+IV38TWS3+V6UKov?=
 =?us-ascii?Q?B2ipKhgkEiuKDhskNoDcWbrkwoqb0cSDM9PawqQKAiaKIZQ7e+d10Z6gsoBR?=
 =?us-ascii?Q?CDfIyLRAXf3RXhLX/C/UzosUPV90M3yUpUn+lZof+DokrKoMlAH9dfgmzZxA?=
 =?us-ascii?Q?04FMPvXvsYkeJxvGWxeZ6/kcuvek1MhXmoS2TK8fDzr+uGpm+CmR+VwRRnkD?=
 =?us-ascii?Q?OUycKfvyr1oT8i3kxXQ1a4nWLVFJI0KLSHIy+OQdRDNy3WfcXtNYAPIzNQxA?=
 =?us-ascii?Q?3d56VyiavZwQ2SDBmHLwi1HlDngD9WmMUhq2na4gckskLwSLhJLAs3NGW+G2?=
 =?us-ascii?Q?3XGi8MP1k0kRA62gYPs8yEHuQk0WLCSOQPO2bGbU9Z31ymtCuezPp7Tqxo0j?=
 =?us-ascii?Q?ef2NahFgyhfGANv9MDqVZMij61eQuFDQYXVMEuBx6kmh64lNZ0PcQLzC5doQ?=
 =?us-ascii?Q?zeov5VP55GLlWgESAm+yjMHtmpiez1RePp9PuV++YSWS/P0phNLZU2fdtNNQ?=
 =?us-ascii?Q?N4ns2uOBN/dGMVfQd943A9LFkSXqqNCCq/3KKsjY9Sv3Q2ddWkLg42MT0b1m?=
 =?us-ascii?Q?6XB8P9Mv6TebNgiCSjl2peuBzOjbRVJuWEDpXHyAxVZi9roT5MLQpB+I7fuO?=
 =?us-ascii?Q?FeYU+gqj2/d/LK4EQ8I2IQefOop62NntsdDVpmWbgpb6Y+HgR493q8iR/iCx?=
 =?us-ascii?Q?LVkxYeUXZ4X5PL7a2gXgv0sEvgH26vKxRntOISHDO5iRdZBtW3hQUfhl4Kc0?=
 =?us-ascii?Q?RSqs0l+yLRLNJ6ftUrNP/X0NBIiD4mVvkHnx+lADymXoydrlFlb8QWj52Fcp?=
 =?us-ascii?Q?jDkhk4TDgsEQ+gigL4JZ6CCkGgEPL/2LI/z67qF/nF3Gx5eo6ioEl+tI73AU?=
 =?us-ascii?Q?It+/LXuOZijEAraGdACtnu2W7/W2H1zhNQVR62BjjpFnX5gSSPCKZjCMzbAr?=
 =?us-ascii?Q?Vw1djX6Rjnee4yCyO1D7lNYScUU8qFD3cQqT/9mlmHufLtlV9RSunW92Im75?=
 =?us-ascii?Q?8O1TTm34eA4ph5D2J6E9OP3hCIRmIp566SLQSlQn7Hg/HJV+aDovwPGcGnY0?=
 =?us-ascii?Q?zzdLeBDuv0rR4isIIgN4QGu6+gWekfX4u4ViEJaMYsMWHvv1pqB2DVYVopns?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wgLbRiVbSCI20DdYsV28YseO1kqppA/LXMNSrAzwQ0jcXEa5PJ6jz+snDEDKPtZc0Bqo0BvhiFVZ96LnaCcIGlTKvpiVrKLep+DOTFl8IECFFWVx5u4NCEdW/OAYRpZsuIB94pa1agdake7fu482E5gNFKUQvnkxp1rnKFZQlpZFi/UC1tYtqkm1mMpxJs+muhXwDl9EPND3swd8RGX1QJd4zT7L/n2f+6P2z4wBmxnLpfhpgANT8Si6py27KqtYc4pIqkENncn8f3JpQfQhSjEzx/DBuvpSpJ2aghPXWSulzYHJvEgKF72QYutT2HzFwJR8BoyfZMvE/AUngoL7iYPxj/OC4dR84biPB/kUt+epXxc/1+6OBh0VPex7SA47QJ5GJme8hiyJvKv8jUYz3518WKU+nVzY/W3XzLfFzZksodrCcL8O+JWGnAxu/CP7UN6CGXQ8XimM4vq4urSnLv/lLB2WIvw1kPfmhu9JsEntJ1ShPbHOhMVJygsQVxo5TSQSX8fRXIb8/DWSZ+8wE2avwHJ9SQYWjnQgW8anzBHZMLHbR3GFnmVtdbqhAx06zE7RBxHk7WHq1CTDP5JuguIs+YPOeha5PAOwYlBvoKw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa783e0-527b-446c-0240-08dc8a4fe30c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 19:51:29.8475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2cE3LHgLur5u8yUYt/YFt2VfTgl6CRD3MrrFJ55b1lWhzW91nMp0HAHWBcwEtDJKjXncZTceDQH5xPq7KAr91n5MyGKYEhR39yEHwGgNMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4947
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_09,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406110136
X-Proofpoint-ORIG-GUID: IAbKTHZseW0mNqjDIBGC32oksKzx5uM0
X-Proofpoint-GUID: IAbKTHZseW0mNqjDIBGC32oksKzx5uM0


Christoph,

Sorry about the delay. Travel got in the way.

>> On the wire between controller and target there's only CRC. If I want to
>> write a "bad" CRC to disk, I have switch the controller to CRC mode. The
>> controller can't convert a "bad" IP checksum to a "bad" CRC. The PI test
>> tooling relies heavily on being able to write "bad" things to disk and
>> read them back to validate that we detect the error.
>
> But how do you even toggle the flag?  There is no no code to do that.
> And if you already have a special kernel module for that it really
> should just use a passthrough request to take care of that.

A passthrough command to the controller?

> Note that unlike the NOCHECK flag which I just cleaned up because they
> were unused, this one actually does get in the way of the architecture
> of the whole series :( We could add a per-bip csum_type but it would
> feel really weird.

Why would it feel weird? That's how it currently works.

The qualification tool issues a flurry of commands injecting errors at
various places in the stack to identify that the right entity (block
layer, controller, storage device) catch a bad checksum, reference tag,
etc. Being able to enable/disable checking at each place in the stack is
important. I also have code for target that does the same thing in the
reverse direction.

-- 
Martin K. Petersen	Oracle Linux Engineering

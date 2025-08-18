Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB00266B40
	for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755505677; cv=none; b=CgFxy1N7SH8AeNiFZz4U9DPdDvGowz3sTIMKOrvaITSXeONxDEZ5oARZDFyXth1hjdZ19NA9IUL94B5DwT5qeev6/aGeL3MR4zEdzJrK4NEVERliR2C+znSj+5Ldp4X5eoljvXqzzif8r+gXoq0ZV/EaqgiVOu2SVZFtLBtd+Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755505677; c=relaxed/simple;
	bh=rq6946DzumILvEIR5XWexmQkysEBR7GbvltHkcSl6YA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S8XkTrDBuUvsIsN0871AcQDiyerSPCp4hycqEdGqvoroPS0L6TaHIb7OLMsD/yczyIIjIwXyel9iTJu+rPSz/PZ1GChJxpHffcrmyej/ApQ+7ItzQgbTKB8RnoXcBc4TBbYj6KpKG0t6CkDTlWtBZ/DGC9DAvzjj8VpWZtnaJNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pH0jjYJT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pH0jjYJT"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I87UDZ021903
	for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 08:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rq6946DzumILvEIR5XWexmQkysEBR7GbvltHkcSl6YA=; b=pH0jjYJTAl7re29P
	eDXYy6doYRSC9/QrUBVDRGmaKfPZCRnt/27BpOESnbmKcDWYQWQE0TN4RjZHB26p
	r31MIs4hA2/C4q4WvJs0F/TcGgCHu/dmVO2NTsFUfLgXGYc273YerMZN4+uFW9F7
	hypGSTOfjNaHRAfD5yZE9ln9D4CBCF4ZoWT6/s894AJcWj4w2Ceci1tqrMg7FZ7T
	8nC/lLMKExRJTWRCvcqmfiA5ilpDfF1xh3HEHJXusTG+HZ4HJHr6VZH5d8Jd3MdY
	0E5ihcuWt8hBw0jAUsx0ZEQNIeQ0WCoiOmTnd4PZxYXj0A6xg9y5MRgUrzX0TcRD
	r1n2kA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48jjc7ux1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 08:27:54 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b471757dec5so7226290a12.3
        for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 01:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755505673; x=1756110473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rq6946DzumILvEIR5XWexmQkysEBR7GbvltHkcSl6YA=;
        b=vM/QNcDH6Kn4lM2DL1SnCXVSy7QoG77D8VghJz1jTYVSgjs5FC9Q1TdzZHqRRMjcto
         XMz7MFnXuKIMmJqtxXzCPCigbBOpXQvxWwfCAmjTvQI+33MMGfcHPhHblDPcq5e8XSnb
         kxdqkyglYRMuyKQpUx8WEzujcrRpx768t74DeUscddy68PerfWo91L2kEx+gf7wO/T6q
         TT8/xD4kpeP9R1pN1eIQSB4KK1igq0WLR5Ihhhrp8iPva98sbTnw+GoKMj0ACwIRo6oI
         8d6thT4NBrok2dvTeuMGkJHuNzifYHfwJuQtHAHcSzsKZ05MHOUjNfUxUXAjHJcWQ6mb
         su/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWcUXIuJS9sh910bVCSLBwLnogiv08ztfZtZP4OZBY+x/4N4R7HasIQ7C0mdCYLEP9bZth3e8w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzq+5fCR9PW7T3BhidbkAQxrSU2JEJnwCgMtVQ82QzaTcqq2Muo
	LIxt6SF0bfvHBIENi/izdj1mN52EG5E6mwt9lg1hyfE/Ywn5qTHiyKOErcSBqU3vKzRr9vuTGeA
	3SYLQS7L3gFB0JWIToJGiPHDMty3TGgZFHVPsG2Jo8eZ/W/NMDhIjd+hvZ/PcDgSouNc7vCCXFN
	7Havia1olKD5d54YXEpZWDms8YcheofhfdJA==
X-Gm-Gg: ASbGncuVOmnRBIt0vXLRUATNrn3zX4HhzyemH0hjrAL6ncA/b3VsJc+/qHZmQd5DWDZ
	sxr93lGikXdUT1X2VjKtc5QymqE3PXc57+vD4IIawgVgf8rkeBpBQczGJovtSNqssztMFvU1EXb
	0P2k0DaJZ5zvO6rxbE3Y8IbQ==
X-Received: by 2002:a17:902:e842:b0:235:ed01:18cd with SMTP id d9443c01a7336-2446d99e6acmr165826815ad.44.1755505673481;
        Mon, 18 Aug 2025 01:27:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxmEX0bC4rGj0GsL0Ofny3nTaPHYYQ7bo5uu9L4GZIVv1jBDAAlTveYAPi+e7gAhEyyevMd3DrrsmVZDn0oyA=
X-Received: by 2002:a17:902:e842:b0:235:ed01:18cd with SMTP id
 d9443c01a7336-2446d99e6acmr165826455ad.44.1755505673065; Mon, 18 Aug 2025
 01:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com> <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
In-Reply-To: <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Mon, 18 Aug 2025 13:57:41 +0530
X-Gm-Features: Ac12FXzcSoeiNhok4BzoYQfoalKvL5KSge90N69qQ3e47Ph8xq7Ih6FtZXa_xiM
Message-ID: <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
Subject: Re: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to memory_get_phys_to_nid
To: David Hildenbrand <david@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Alison Schofield <alison.schofield@intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-acpi@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
        linux-cxl@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAzMyBTYWx0ZWRfXwf49lbWjipqL
 1j1jDj04TQh3hqaQGtRaG2AIJwJXLuaJ5cr79fvBB1wBzKz5xWm7wb4XCB23YqV0/iWGlrs6UMB
 l2k+cH9P0tNprN2RInzEKjiUIYiNB6lM9hsvoYlqe5FAIFiyesDQHPzRY6ixb7cy8BG9MBy/Q9V
 QgOQ5mz5cvXzUAReaWn2dQ4Gx/kQVGYE11TC3BcwimFtUflGncROPedv59yX7lFSkRxCFISeW71
 sX130YcZth/0Rwp9Bd/5BcwrcIf2QyUw4hKRGW+cX5mzsZluMSTB66McI+cTi3SoCMZ7LjqT/9y
 hHeIWXTlbfkfycXzhp8i2O/gbIiP8GIG5a6lFi4+DmwpeYhxdjelO5I1a4gJ+9h0xFHUD0CGOLP
 Zxo8hK+K
X-Authority-Analysis: v=2.4 cv=c4mrQQ9l c=1 sm=1 tr=0 ts=68a2e40a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8 a=uSFNSxTeKwDZCnUuY58A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: RxJQysgizgqCax3-XqJzt8rkvCSrgR0I
X-Proofpoint-ORIG-GUID: RxJQysgizgqCax3-XqJzt8rkvCSrgR0I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508160033

On Mon, Aug 18, 2025 at 12:29=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
> > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
> > The function `memory_add_physaddr_to_nid` seems a misnomer.
> > It does not to "add" a physical address to a NID mapping,
> > but rather it gets the NID associated with a given physical address.
>
> You probably misunderstood what the function is used for: memory hotplug
> aka "memory_add".
Thanks for your feedback. I get the part about memory hotplug here but
using memory_add still seems a little odd as it doesn't truly reflect
what this api is doing.
However, I agree that my current suggestion
may not be the perfect choice for the name, so I'm open to suggestions.

Perhaps, something like "memory_add_get_nid_by_phys" may work here?
>
> This patch is making matters worse by stripping that detail, unfortunatel=
y.
>
>
> --
> Cheers
>
> David / dhildenb
>
Thanks and Regards
Pratyush

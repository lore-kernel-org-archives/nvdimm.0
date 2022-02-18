Received: from 1.mo548.mail-out.ovh.net (1.mo548.mail-out.ovh.net [178.32.121.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007072F2E
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 12:33:50 +0000 (UTC)
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.141])
	by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 61E4A2312C;
	Fri, 18 Feb 2022 07:44:09 +0000 (UTC)
Received: from kaod.org (37.59.142.96) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 18 Feb
 2022 08:44:08 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-96R001aec2483b-258d-44f3-8f80-6200557211f5,
                    2ADC5E975130A5AC73D526B447F5AC0F6E2F692A) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <66c4c578-d8ac-8a2c-91d0-9c6b26ed39eb@kaod.org>
Date: Fri, 18 Feb 2022 08:44:02 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v7 0/3] spapr: nvdimm: Introduce spapr-nvdimm device
Content-Language: en-US
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, <mst@redhat.com>,
	<ani@anisinha.ca>, <danielhb413@gmail.com>, <david@gibson.dropbear.id.au>,
	<groug@kaod.org>, <imammedo@redhat.com>, <xiaoguangrong.eric@gmail.com>,
	<qemu-ppc@nongnu.org>
CC: <qemu-devel@nongnu.org>, <aneesh.kumar@linux.ibm.com>,
	<nvdimm@lists.linux.dev>, <kvm-ppc@vger.kernel.org>
References: <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
From: =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG2EX1.mxp5.local (172.16.2.11) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: f1b63f11-3ead-4642-8ee1-f9060d60f342
X-Ovh-Tracer-Id: 5641040012273814459
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrjeelgdduudduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepueetveejhffgvedvueejleefgeetkeduvedugfeitdelfeeitefghedukeetuedtnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpphihrdgurghtrgenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepghhrohhugheskhgrohgurdhorhhg

On 2/4/22 09:15, Shivaprasad G Bhat wrote:
> If the device backend is not persistent memory for the nvdimm, there
> is need for explicit IO flushes to ensure persistence.
> 
> On SPAPR, the issue is addressed by adding a new hcall to request for
> an explicit flush from the guest when the backend is not pmem.
> So, the approach here is to convey when the hcall flush is required
> in a device tree property. The guest once it knows the device needs
> explicit flushes, makes the hcall as and when required.
> 
> It was suggested to create a new device type to address the
> explicit flush for such backends on PPC instead of extending the
> generic nvdimm device with new property. So, the patch introduces
> the spapr-nvdimm device. The new device inherits the nvdimm device
> with the new bahviour such that if the backend has pmem=no, the
> device tree property is set by default.
> 
> The below demonstration shows the map_sync behavior for non-pmem
> backends.
> (https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py.data/map_sync.c)
> 
> The pmem0 is from spapr-nvdimm with with backend pmem=on, and pmem1 is
> from spapr-nvdimm with pmem=off, mounted as
> /dev/pmem0 on /mnt1 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> /dev/pmem1 on /mnt2 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> 
> [root@atest-guest ~]# ./mapsync /mnt1/newfile ----> When pmem=on
> [root@atest-guest ~]# ./mapsync /mnt2/newfile ----> when pmem=off
> Failed to mmap  with Operation not supported
> 
> First patch adds the realize/unrealize call backs to the generic device
> for the new device's vmstate registration. The second patch implements
> the hcall, adds the necessary vmstate properties to spapr machine structure
> for carrying the hcall status during save-restore. The nature of the hcall
> being asynchronus, the patch uses aio utilities to offload the flush. The
> third patch introduces the spapr-nvdimm device, adds the device tree
> property for the guest when spapr-nvdimm is used with pmem=no on the
> backend. Also adds new property pmem-override(?, suggest if you have better
> name) to the spapr-nvdimm which hints at forcing the hcall based flushes even
> on pmem backed devices.
> 
> The kernel changes to exploit this hcall is at
> https://github.com/linuxppc/linux/commit/75b7c05ebf9026.patch



Applied for ppc-7.0

Thanks,

C.

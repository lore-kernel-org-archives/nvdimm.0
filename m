Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D1833FA
	for <nvdimm@lists.linux.dev>; Tue, 28 Feb 2023 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677593053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ESrld006RWsyPkhdVerW4JO9w3LuFA1DAtayIv7Uao=;
	b=cTt6imcK48pkduuip5E0TE2eAhSFNO99seWi2cZrqLfKzeL7xKxArmpPuoqmH/xixtHn9Q
	TgyJKQ/vd+WBonHYpfmhmsJ64dVuJKjmD29lyaBd8rLS+OBtJGPErJ0r78IeyjkgIF/8/8
	UzXLtIE4RpdaB7D4M+OpzcNW6NwLdJs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-ee3cnWmIMkS4QAFkSqBm9Q-1; Tue, 28 Feb 2023 09:04:05 -0500
X-MC-Unique: ee3cnWmIMkS4QAFkSqBm9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C74C61871D9A;
	Tue, 28 Feb 2023 14:03:56 +0000 (UTC)
Received: from localhost (ovpn-13-194.pek2.redhat.com [10.72.13.194])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4401418EC6;
	Tue, 28 Feb 2023 14:03:54 +0000 (UTC)
Date: Tue, 28 Feb 2023 22:03:49 +0800
From: Baoquan He <bhe@redhat.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>,
	"k-hagio-ab@nec.com" <k-hagio-ab@nec.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
	"ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Subject: Re: [RFC][nvdimm][crash] pmem memmap dump support
Message-ID: <Y/4JxQtnmYrZgVwF@MiWiFi-R3L-srv>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 02/23/23 at 06:24am, lizhijian@fujitsu.com wrote:
> Hello folks,
> 
> This mail raises a pmem memmap dump requirement and possible solutions, but they are all still premature.
> I really hope you can provide some feedback.
> 
> pmem memmap can also be called pmem metadata here.
> 
> ### Background and motivate overview ###
> ---
> Crash dump is an important feature for trouble shooting of kernel. It is the final way to chase what
> happened at the kernel panic, slowdown, and so on. It is the most important tool for customer support.
> However, a part of data on pmem is not included in crash dump, it may cause difficulty to analyze
> trouble around pmem (especially Filesystem-DAX).
> 
> 
> A pmem namespace in "fsdax" or "devdax" mode requires allocation of per-page metadata[1]. The allocation
> can be drawn from either mem(system memory) or dev(pmem device), see `ndctl help create-namespace` for
> more details. In fsdax, struct page array becomes very important, it is one of the key data to find
> status of reverse map.
> 
> So, when metadata was stored in pmem, even pmem's per-page metadata will not be dumped. That means
> troubleshooters are unable to check more details about pmem from the dumpfile.
> 
> ### Make pmem memmap dump support ###
> ---
> Our goal is that whether metadata is stored on mem or pmem, its metadata can be dumped and then the
> crash-utilities can read more details about the pmem. Of course, this feature can be enabled/disabled.
> 
> First, based on our previous investigation, according to the location of metadata and the scope of
> dump, we can divide it into the following four cases: A, B, C, D.
> It should be noted that although we mentioned case A&B below, we do not want these two cases to be
> part of this feature, because dumping the entire pmem will consume a lot of space, and more importantly,
> it may contain user sensitive data.
> 
> +-------------+----------+------------+
> |\+--------+\     metadata location   |
> |            ++-----------------------+
> | dump scope  |  mem     |   PMEM     |
> +-------------+----------+------------+
> | entire pmem |     A    |     B      |
> +-------------+----------+------------+
> | metadata    |     C    |     D      |
> +-------------+----------+------------+
> 
> Case A&B: unsupported
> - Only the regions listed in PT_LOAD in vmcore are dumpable. This can be resolved by adding the pmem
> region into vmcore's PT_LOADs in kexec-tools.
> - For makedumpfile which will assume that all page objects of the entire region described in PT_LOADs
> are readable, and then skips/excludes the specific page according to its attributes. But in the case
> of pmem, 1st kernel only allocates page objects for the namespaces of pmem, so makedumpfile will throw
> errors[2] when specific -d options are specified.
> Accordingly, we should make makedumpfile to ignore these errors if it's pmem region.
> 
> Because these above cases are not in our goal, we must consider how to prevent the data part of pmem
> from reading by the dump application(makedumpfile).
> 
> Case C: native supported
> metadata is stored in mem, and the entire mem/ram is dumpable.
> 
> Case D: unsupported && need your input
> To support this situation, the makedumpfile needs to know the location of metadata for each pmem
> namespace and the address and size of metadata in the pmem [start, end)
> 
> We have thought of a few possible options:
> 
> 1) In the 2nd kernel, with the help of the information from /sys/bus/nd/devices/{namespaceX.Y, daxX.Y, pfnX.Y}
> exported by pmem drivers, makedumpfile is able to calculate the address and size of metadata
> 2) In the 1st kernel, add a new symbol to the vmcore. The symbol is associated with the layout of
> each namespace. The makedumpfile reads the symbol and figures out the address and size of the metadata.
> 3) others ?
> 
> But then we found that we have always ignored a user case, that is, the user could save the dumpfile
> to the pmem. Neither of these two options can solve this problem, because the pmem drivers will
> re-initialize the metadata during the pmem drivers loading process, which leads to the metadata
> we dumped is inconsistent with the metadata at the moment of the crash happening.
> Simply, can we just disable the pmem directly in 2nd kernel so that previous metadata will not be
> destroyed? But this operation will bring us inconvenience that 2nd kernel doesn’t allow user storing
> dumpfile on the filesystem/partition based on pmem.

1) In kernel side, export info of pmem meta data;
2) in makedumpfile size, add an option to specify if we want to dump
   pmem meta data; An option or in dump level?
3) In glue script, detect and warn if pmem data is in pmem and wanted,
   and dump target is the same pmem.

Does this work for you?

Not sure if above items are all do-able. As for parking pmem device
till in kdump kernel, I believe intel pmem expert know how to achieve
that. If there's no way to park pmem during kdump jumping, case D) is
daydream.

Thanks
Baoquan


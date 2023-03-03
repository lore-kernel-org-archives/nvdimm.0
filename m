Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50F1FB3
	for <nvdimm@lists.linux.dev>; Fri,  3 Mar 2023 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677835302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XjkqTVt2QtWZVOvq30arJHAo3lGgaTpqVjd41aCw5H0=;
	b=avG8U2G1wmjYN6yzS+foayP2HHMCuXbPSrtjFR2YNiLNFPNAAz9+/C4JL6egNM5+3abziH
	TwS6R4uTuCikvO4fImzDVQCFiU9BDkQiWWHDewIbt58KV0y6bRj8pkyvLO5te7yqk1BTZD
	zsegmrBfY6gT7yW7Hp5Hcnzs/R3aM28=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-vMJPGrxyObqdC6zLBD8I6A-1; Fri, 03 Mar 2023 04:21:38 -0500
X-MC-Unique: vMJPGrxyObqdC6zLBD8I6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA245803D50;
	Fri,  3 Mar 2023 09:21:37 +0000 (UTC)
Received: from localhost (ovpn-13-150.pek2.redhat.com [10.72.13.150])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B15B82166B34;
	Fri,  3 Mar 2023 09:21:36 +0000 (UTC)
Date: Fri, 3 Mar 2023 17:21:29 +0800
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
Message-ID: <ZAG8GVUdiKx9LfWg@MiWiFi-R3L-srv>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <Y/4JxQtnmYrZgVwF@MiWiFi-R3L-srv>
 <777f338f-09cb-d9f4-fe5f-3a6f059e4b02@fujitsu.com>
 <Y/8KFYraba1Lsh5f@MiWiFi-R3L-srv>
 <ddae42f1-749b-7665-28fa-89a3731c7b4a@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ddae42f1-749b-7665-28fa-89a3731c7b4a@fujitsu.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 03/03/23 at 02:27am, lizhijian@fujitsu.com wrote:
> 
> 
> On 01/03/2023 16:17, Baoquan He wrote:
> > On 03/01/23 at 06:27am, lizhijian@fujitsu.com wrote:
> > ......
> >> Hi Baoquan
> >>
> >> Greatly appreciate your feedback.
> >>
> >>
> >>> 1) In kernel side, export info of pmem meta data;
> >>> 2) in makedumpfile size, add an option to specify if we want to dump
> >>>      pmem meta data; An option or in dump level?
> >>
> >> Yes, I'm working on these 2 step.
> >>
> >>> 3) In glue script, detect and warn if pmem data is in pmem and wanted,
> >>>      and dump target is the same pmem.
> >>>
> >>
> >> The 'glue script' means the scirpt like '/usr/bin/kdump.sh' in 2nd kernel? That would be an option,
> >> Shall we abort this dump if "pmem data is in pmem and wanted, and dump target is the same pmem" ?
> > 
> > Guess you are saying scripts in RHEL/centos/fedora, and yes if I guess
> > righ. Other distros could have different scripts. For kdump, we need
> > load kdump kernel/initramfs in advance, then wait to capture any crash.
> > When we load, we can detect and check whether the environment and
> > setup is expected. If not, we can warn or error out message to users.
> 
> 
> IIUC, take fedora for example,
> T1: in 1st kernel, kdump.service(/usr/bin/kdumpctl) will do a sanity check before loading kernel and initramfs.
>      In this moment, as you said "we can detect and check whether the environment and setup is expected. If not,
>      we can warn or error out message to users."
>      I think we should abort the kdump service if "pmem data is in pmem and wanted, and dump target is the same pmem".
>      For OS administrators, they could either change the dump target or disable the pmem metadadata dump to make
>      kdump.service work again.
> 
> But kdump.service is distros independent, some OS administrators will use `kexec` command directly instead of service/script helpers.

Yeah, we can add document in kernel or somewhere else that dumping to
pmem is dangerous, especially when we want to dump pmem meta. People who
dare use kexec command directly, should handle it by her/his own.

> 
> > We don't need to do the checking until crash is triggered, then decide
> > to abort the dump or not.
> 
> T2: in 2nd kernel, since 1st kernel's glue scripts vary by distribution, we have to do the sanity check again to decide
> to abort the dump or not.

Hmm, we may not need to worry about that. kernel just need to do its own
business, not touching pmem data during kdump jumping and booting, and
provide way to allow makedumpfile to read out pmem meta. Anything else
should be taken care of by user or distros. 


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64B533F2
	for <nvdimm@lists.linux.dev>; Sun,  4 Jun 2023 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685883604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OeMePCjN4P2ymC2CrBoEd8HNclMVWoMJVZ9Ma4h8Q+4=;
	b=HONN0B4HvrdFxOt2PqGXdlAiWXggBnJ96pIG8tikiQ8iAWx4YwPIVAwhpxDQGaMnKjsnvA
	ygA+fVhgV1ze6Mgrn9ZQHWd9j+5VRGHEFdUtObPMkO3TvDHzJitwSd62BBI60BnWLhlF0C
	I+A7xPJ8yU29NQDxFyyt8C7xlqYFBKk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592--Vh0TdJLOgG9xAeBLXaJIA-1; Sun, 04 Jun 2023 09:00:00 -0400
X-MC-Unique: -Vh0TdJLOgG9xAeBLXaJIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22711811E78;
	Sun,  4 Jun 2023 12:59:59 +0000 (UTC)
Received: from localhost (ovpn-12-83.pek2.redhat.com [10.72.12.83])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E445C1121314;
	Sun,  4 Jun 2023 12:59:55 +0000 (UTC)
Date: Sun, 4 Jun 2023 20:59:52 +0800
From: Baoquan He <bhe@redhat.com>
To: Li Zhijian <lizhijian@fujitsu.com>, dan.j.williams@intel.com
Cc: kexec@lists.infradead.org, nvdimm@lists.linux.dev,
	Kazuhito Hagio <k-hagio-ab@nec.com>,
	Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com, ruansy.fnst@fujitsu.com,
	y-goto@fujitsu.com, yangx.jy@fujitsu.com,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Dave Young <dyoung@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org
Subject: Re: [RFC PATCH v3 0/3] pmem memmap dump support
Message-ID: <ZHyKyHiTYH80HUjF@MiWiFi-R3L-srv>
References: <20230602102656.131654-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602102656.131654-1-lizhijian@fujitsu.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

Hi Zhijian,

On 06/02/23 at 06:26pm, Li Zhijian wrote:
> Hello folks,
> 
> After sending out the previous version of the patch set, we received some comments,
> and we really appreciate your input. However, as you can see, the current patch
> set is still in its early stages, especially in terms of the solution selection,
> which may still undergo changes.

Thanks for the effort to make it and improve. And add Kazu and Simon to
the CC because they maintain kexec-tools and makedumpfile utility.

For better reviewing, I would suggest splitting the patches into
differet patchset for different component or repo. Here, it's obviouly
has kernel patchset, kexec-tools patch and makedumpfile patchset.

For the kernel patches, it looks straightforward and clear, if Dan can
approve it from nvdimm side, everything should be fine. Then next we can
focus on the relevant kexec-tools and makedumpfile utility support.

Thanks
Baoquan


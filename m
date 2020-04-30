Return-Path: <SRS0=TPW+=6O=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE00AC47254
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Apr 2020 22:24:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 821A52070B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Apr 2020 22:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nB8mUJ6P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 821A52070B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ED992110EE30C;
	Thu, 30 Apr 2020 15:22:52 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 46BCE1010632A
	for <linux-nvdimm@lists.01.org>; Thu, 30 Apr 2020 15:22:51 -0700 (PDT)
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 94AC1206D9;
	Thu, 30 Apr 2020 22:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588285444;
	bh=U2wS06jC9o9pM52AkSococGuM+XgTOL9WOXR44wwwmQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nB8mUJ6Pr+ljhrNsFLIKSdctC/llz+t2pcx7JDOh0oPr8VKQWeTBxDI7E+xMeStLC
	 YJG+PTTpUS++FiCEfMHnakKMR5tEwypkxH9WzJR3NY+WaET9iOTNnwJL1dKYZQ2hQo
	 n2b6cYRnfH+6fRINH9l/gw+LAzU9FuEWW69YHNxU=
Date: Thu, 30 Apr 2020 15:24:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 2/3] mm/memory_hotplug: Introduce
 MHP_NO_FIRMWARE_MEMMAP
Message-Id: <20200430152403.e0d6da5eb1cad06411ac6d46@linux-foundation.org>
In-Reply-To: <b28c9e02-8cf2-33ae-646b-fe50a185738e@redhat.com>
References: <20200430102908.10107-1-david@redhat.com>
	<20200430102908.10107-3-david@redhat.com>
	<87pnbp2dcz.fsf@x220.int.ebiederm.org>
	<1b49c3be-6e2f-57cb-96f7-f66a8f8a9380@redhat.com>
	<871ro52ary.fsf@x220.int.ebiederm.org>
	<373a6898-4020-4af1-5b3d-f827d705dd77@redhat.com>
	<875zdg26hp.fsf@x220.int.ebiederm.org>
	<b28c9e02-8cf2-33ae-646b-fe50a185738e@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Message-ID-Hash: AF27Y3NZW5KBBJVJHA7BXYLOCNHA2ZDP
X-Message-ID-Hash: AF27Y3NZW5KBBJVJHA7BXYLOCNHA2ZDP
X-MailFrom: akpm@linux-foundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-hyperv@vger.kernel.org, linux-s390@vger.kernel.org, xen-devel@lists.xenproject.org, Michal Hocko <mhocko@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Michal Hocko <mhocko@suse.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Baoquan He <bhe@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AF27Y3NZW5KBBJVJHA7BXYLOCNHA2ZDP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 30 Apr 2020 20:43:39 +0200 David Hildenbrand <david@redhat.com> wrote:

> > 
> > Why does the firmware map support hotplug entries?
> 
> I assume:
> 
> The firmware memmap was added primarily for x86-64 kexec (and still, is
> mostly used on x86-64 only IIRC). There, we had ACPI hotplug. When DIMMs
> get hotplugged on real HW, they get added to e820. Same applies to
> memory added via HyperV balloon (unless memory is unplugged via
> ballooning and you reboot ... the the e820 is changed as well). I assume
> we wanted to be able to reflect that, to make kexec look like a real reboot.
> 
> This worked for a while. Then came dax/kmem. Now comes virtio-mem.
> 
> 
> But I assume only Andrew can enlighten us.
> 
> @Andrew, any guidance here? Should we really add all memory to the
> firmware memmap, even if this contradicts with the existing
> documentation? (especially, if the actual firmware memmap will *not*
> contain that memory after a reboot)

For some reason that patch is misattributed - it was authored by
Shaohui Zheng <shaohui.zheng@intel.com>, who hasn't been heard from in
a decade.  I looked through the email discussion from that time and I'm
not seeing anything useful.  But I wasn't able to locate Dave Hansen's
review comments.

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

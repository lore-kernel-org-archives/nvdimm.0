Return-Path: <SRS0=xduE=FM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD9FC4361B
	for <linux-nvdimm@archiver.kernel.org>; Tue,  8 Dec 2020 13:00:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E54FC23A3C
	for <linux-nvdimm@archiver.kernel.org>; Tue,  8 Dec 2020 13:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E54FC23A3C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8CE0A100ED480;
	Tue,  8 Dec 2020 05:00:56 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1231::1; helo=merlin.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 55F7E100EF27B
	for <linux-nvdimm@lists.01.org>; Tue,  8 Dec 2020 05:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tcqzNwG/JqN84m8ZHCLfOHnqSs0WzIMVJzRH59zvaU8=; b=FS+tu15skUVXKE2wB9GoISqub2
	Y+HEvZy8ejZbKnc+5SN6BrB0pQIU6uF3BnmyvwcxpsoJIoeTYBxoGfv2XqxtxAe3WxLH/Gjivqu5/
	5TB8Tw2z0eOTR5SD3Zk+JdrkIsKsYjmnK2Ls+hMO5qg5rfxIjFbRalR1tD0/fEPhavF5vEWoXM17j
	3UYM5DTLIQAU0/dLtUpBzFiPGnl4U7/bimTQ19TEjRfLmD+TwhzfPwEouwj1tyDWAl5SD63LSSofg
	oet8X6PLhLa/FcBiSTxBBvYWCuJRtA7i+90obmsZTGTqvpgRRUX1azskvAKJVi7rOM34BLGtHqW2N
	8zyqWV5w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kmcbj-00019L-31; Tue, 08 Dec 2020 13:00:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AA7753011F0;
	Tue,  8 Dec 2020 14:00:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 20A87200AABBA; Tue,  8 Dec 2020 14:00:40 +0100 (CET)
Date: Tue, 8 Dec 2020 14:00:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC][PATCH 1/2] libnvdimm: Introduce ND_CMD_GET_STAT to
 retrieve nvdimm statistics
Message-ID: <20201208130040.GZ2414@hirez.programming.kicks-ass.net>
References: <20201108211549.122018-1-vaibhav@linux.ibm.com>
 <CAPcyv4h0PAPyYoea2oxqw_mOZ-Ec-o1MwcdSN0gf5UXqZqjafQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h0PAPyYoea2oxqw_mOZ-Ec-o1MwcdSN0gf5UXqZqjafQ@mail.gmail.com>
Message-ID-Hash: PAZMO4JS7MDUGF2URIO62CZ4N5R7UYCU
X-Message-ID-Hash: PAZMO4JS7MDUGF2URIO62CZ4N5R7UYCU
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PAZMO4JS7MDUGF2URIO62CZ4N5R7UYCU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 07, 2020 at 04:54:21PM -0800, Dan Williams wrote:
> [ add perf maintainers ]
> 
> On Sun, Nov 8, 2020 at 1:16 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
> >
> > Implement support for exposing generic nvdimm statistics via newly
> > introduced dimm-command ND_CMD_GET_STAT that can be handled by nvdimm
> > command handler function and provide values for these statistics back
> > to libnvdimm. Following generic nvdimm statistics are defined as an
> > enumeration in 'uapi/ndctl.h':
> >
> > * "media_reads" : Number of media reads that have occurred since reboot.
> > * "media_writes" : Number of media writes that have occurred since reboot.
> > * "read_requests" : Number of read requests that have occurred since reboot.
> > * "write_requests" : Number of write requests that have occurred since reboot.
> 
> Perhaps document these as "since device reset"? As I can imagine some
> devices might have a mechanism to reset the count outside of "reboot"
> which is a bit ambiguous.
> 
> > * "total_media_reads" : Total number of media reads that have occurred.
> > * "total_media_writes" : Total number of media writes that have occurred.
> > * "total_read_requests" : Total number of read requests that have occurred.
> > * "total_write_requests" : Total number of write requests that have occurred.
> >
> > Apart from ND_CMD_GET_STAT ioctl these nvdimm statistics are also
> > exposed via sysfs '<nvdimm-device>/stats' directory for easy user-space
> > access like below:
> >
> > /sys/class/nd/ndctl0/device/nmem0/stats # tail -n +1 *
> > ==> media_reads <==
> > 252197707602
> > ==> media_writes <==
> > 20684685172
> > ==> read_requests <==
> > 658810924962
> > ==> write_requests <==
> > 404464081574
> 
> Hmm, I haven't looked but how hard would it be to plumb these to be
> perf counter-events. So someone could combine these with other perf
> counters?
> 
> > In case a specific nvdimm-statistic is not supported than nvdimm
> > command handler function can simply return an error (e.g -ENOENT) for
> > request to read that nvdimm-statistic.
> 
> Makes sense, but I expect the perf route also has a way to enumerate
> which statistics / counters are supported. I'm not opposed to also
> having them in sysfs, but I think perf support should be a first class
> citizen.

arch/x86/events/msr.c might be a good starting point for a software pmu
delivering pure counters.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

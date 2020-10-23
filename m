Return-Path: <SRS0=UOT5=D6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C7DC4363A
	for <linux-nvdimm@archiver.kernel.org>; Fri, 23 Oct 2020 17:28:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE3DC21527
	for <linux-nvdimm@archiver.kernel.org>; Fri, 23 Oct 2020 17:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE3DC21527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E8AF016349704;
	Fri, 23 Oct 2020 10:28:34 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=msuchanek@suse.de; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3A72A1633C8FE
	for <linux-nvdimm@lists.01.org>; Fri, 23 Oct 2020 10:28:32 -0700 (PDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A965DAB95;
	Fri, 23 Oct 2020 17:28:30 +0000 (UTC)
Date: Fri, 23 Oct 2020 19:28:29 +0200
From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
To: vaibhav@linux.ibm.com
Subject: Re: Feedback requested: Exposing NVDIMM performance statistics in a
 generic way
Message-ID: <20201023192829.3ee3c1a7@naga.suse.cz>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
In-Reply-To: <87r1v3lwcn.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-ID-Hash: MBTUMF7JL7ZBM75P3B3GECSLQWR3QZEH
X-Message-ID-Hash: MBTUMF7JL7ZBM75P3B3GECSLQWR3QZEH
X-MailFrom: msuchanek@suse.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: alastair@d-silva.org, aneesh.kumar@linux.ibm.com, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MBTUMF7JL7ZBM75P3B3GECSLQWR3QZEH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

On Thu, May 28, 2020 at 11:59 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
> Thanks for this taking time to look into this Dan,
>
> Agree with the points you have made earlier that I am summarizing below:
>
> * This is better done in ndctl rather than ipmctl.
> * Should only expose general performance metrics and not performance
>   counters. Performance counter should be exposed via perf
> * Vendor specific metrics to be separated from generic performance
>   metrics.
>
> One way to split generic and vendor specific metrics might be to report
> generic performance metrics together with dimm health metrics such as
> "temprature_celsius" or "spares_percentage" that are already reported in
> by dimm health output.
>
> Vendor specific performance metrics can be reported as a seperate object
> in the json output. Something similar to output below:
>
> # ndctl list -DH --stats --vendor-stats
> [
>   {
>     "dev":"nmem0",
>     "health":{
>       "health_state":"ok",
>       "shutdown_state":"clean",
>       "temperature_celsius":48.00,
>       "spares_percentage":10,
>
>       /* Generic performance metrics/stats */
>       "TotalMediaReads": 18929,
>       "TotalMediaWrites": 0,
>       ....
>     }
>
>     /* Vendor specific stats for the dimm */
>     "vendor-stats": {
>     "Controller Reset Count":10
>     "Controller Reset Elapsed Time": 3600
>     "Power-on Seconds": 3600

How do you tell generic from vendor-specific stats, though?

Controller reset count and power-on time may not be reported by some
controllers but sound pretty generic.

Even if you declare that the stats reported by all controllers
available at this moment are generic a later one may not report some of
these 'generic' statistics, or report them in different way/units, or
may simply not report anything at all for some technical reason.

Kernels that do not have this feature will not report anything at all
either.

Thanks

Michal
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

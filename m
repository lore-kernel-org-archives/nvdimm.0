Return-Path: <SRS0=NSLz=BB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F219EC433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 22 Jul 2020 05:29:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6AC2207DD
	for <linux-nvdimm@archiver.kernel.org>; Wed, 22 Jul 2020 05:29:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6AC2207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A2F781247FDBA;
	Tue, 21 Jul 2020 22:29:12 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.43; helo=mga05.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5B93D1247B8F8
	for <linux-nvdimm@lists.01.org>; Tue, 21 Jul 2020 22:29:09 -0700 (PDT)
IronPort-SDR: N+iAhLM1cRs59VG0UqPtH6Qzir9SfTBCt0gAmTxiCmZYoO2KmTai3xGFkkA3t4563k5f+N6dWu
 yFn6p6dsAyoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="235137308"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800";
   d="scan'208";a="235137308"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 22:29:08 -0700
IronPort-SDR: ksH3EFs9n4OFlGYxloEeRwh6M9dy3bsIvSt6A8ZwWavVT7iOte54F0eudqq2ALW/NPGua1AEqF
 cSKFz/RjXczw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800";
   d="scan'208";a="392573213"
Received: from vverma7-mobl4.lm.intel.com (HELO localhost6.localdomain6) ([10.255.75.30])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jul 2020 22:29:08 -0700
Message-ID: <e5887e208e958938f134591a53d02a7402d8b8a4.camel@intel.com>
Subject: Re: [ndctl RESEND PATCH v2] monitor: Add epoll timeout for forcing
 a full dimm health check
From: Vishal Verma <vishal.l.verma@intel.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linux-nvdimm@lists.01.org
Date: Tue, 21 Jul 2020 23:29:08 -0600
In-Reply-To: <20200722052455.339169-1-vaibhav@linux.ibm.com>
References: <20200722052455.339169-1-vaibhav@linux.ibm.com>
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Message-ID-Hash: GGEY4EIESNAV4KK2DCI2DJJY4ISIENGI
X-Message-ID-Hash: GGEY4EIESNAV4KK2DCI2DJJY4ISIENGI
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/GGEY4EIESNAV4KK2DCI2DJJY4ISIENGI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2020-07-22 at 10:54 +0530, Vaibhav Jain wrote:
> This patch adds a new command argument to the 'monitor' command namely
> '--poll' that triggers a call to notify_dimm_event() at regular
> intervals forcing a periodic check of status/events for the nvdimm
> objects i.e. bus, dimms, regions or namespaces.
> 
> This behavior is useful for dimms that do not support event notifications
> in case the health status of an nvdimm changes. This is especially
> true in case of PAPR-SCM nvdimms as the PHYP hypervisor doesn't provide
> any notifications to the guest kernel on a change in nvdimm health
> status. In such case periodic polling of the is the only way to track
> the health of a nvdimm.
> 
> The patch updates monitor_event() adding a timeout value to
> epoll_wait() call. Also to prevent the possibility of a single dimm
> generating enough events thereby preventing check for status of other
> nvdimms objects, a 'fullpoll_ts' time-stamp is added to keep track of
> when full check of all nvdimms objects happened. If after epoll_wait()
> returns 'fullpoll_ts' time-stamp indicates last a full status check
> for nvdimm objects happened beyond 'poll-interval' seconds then a full
> status check is enforced.
> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog:
> 
> Resend
> * None
> 
Hi Vaibhav,

I do have this queued up in my staging branch, I've just yet to push it out :)

Thanks for the ping!
-Vishal


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

Return-Path: <SRS0=XqkJ=XG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3066BC49ED6
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Sep 2019 17:42:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CEE922081B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Sep 2019 17:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSwhVdE5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEE922081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 479AC202BDCB0;
	Wed, 11 Sep 2019 10:43:03 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=vishal@kernel.org;
 receiver=linux-nvdimm@lists.01.org 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FD2B202BDCAD
 for <linux-nvdimm@lists.01.org>; Wed, 11 Sep 2019 10:43:02 -0700 (PDT)
Received: from vverma7-desk1.lm.intel.com (fmdmzpr03-ext.fm.intel.com
 [192.55.54.38])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 66AF02081B;
 Wed, 11 Sep 2019 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1568223773;
 bh=4AhEgo9vl2f7omSzUtySKEhZ1c9Xcy2rH8glTF9VUJI=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=VSwhVdE5fzpuM29yDxj3kKqssprsCZq42/I4RTqz8FVYizhVDlZs5VzWJ/FvY9Men
 ZHALWRkR+GGk0sY3gQybt83dt6VV0X6ymalcnDm8a2E/fsZ2r/RHRe8AdbqDcxwECl
 XnDBLr3PQqJ5e4aP4Mb09LFGTrtTF1j6dyprKyLQ=
Message-ID: <71b87dfa4de7c85f4f888f001b23609d0a07b2c8.camel@kernel.org>
Subject: Re: [Ksummit-discuss] [PATCH v2 3/3] libnvdimm, MAINTAINERS:
 Maintainer Entry Profile
From: Vishal Verma <vishal@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Date: Wed, 11 Sep 2019 11:42:52 -0600
In-Reply-To: <156821693963.2951081.11214256396118531359.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156821692280.2951081.18036584954940423225.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156821693963.2951081.11214256396118531359.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

> Document the basic policies of the libnvdimm subsystem and provide a first
> example of a Maintainer Entry Profile for others to duplicate and edit.
> 
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/nvdimm/maintainer-entry-profile.rst |   64 +++++++++++++++++++++
>  MAINTAINERS                                       |    4 +
>  2 files changed, 68 insertions(+)
>  create mode 100644 Documentation/nvdimm/maintainer-entry-profile.rst
> 
Looks good to me,
Acked-by: Vishal Verma <vishal.l.verma@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

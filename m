Return-Path: <SRS0=rtTk=XP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF1DC3A5A2
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Sep 2019 18:48:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62D64208C0
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Sep 2019 18:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Xbc0Tw00"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62D64208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9286C202ECFB3;
	Fri, 20 Sep 2019 11:47:41 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=2607:f8b0:4864:20::344; helo=mail-ot1-x344.google.com;
 envelope-from=dan.j.williams@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B411202ECFAE
 for <linux-nvdimm@lists.01.org>; Fri, 20 Sep 2019 11:47:39 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id z6so7069202otb.2
 for <linux-nvdimm@lists.01.org>; Fri, 20 Sep 2019 11:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20150623.gappssmtp.com; s=20150623;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=bWILoTj9JA6Tmk0XrQauVIYwOVRzoTVZU/UwHFJ7pGk=;
 b=Xbc0Tw00pfkpPXBYsZqPYHpa3d9ms5TsYVXqBZnre720ipyzwhOJmsuvqb4JaFjRVV
 QNjksrMhRSs5GHv6tVygvCcdd/+BnGqRYLS8OH8q7y5WciQgh0jgzrxvdM0eors+5ma0
 Mb1OtKsbk6N0LKhCnsxH1iqJvXehBGUWOt4f3viLauHRBviQFyI5f9IM+JAk+Q0f/mvT
 Epurhzb6FggJlj8vK60talBmEhiPWiwUfn1nB5T503Ybcuy53O/pdVkqaQwt4vbz6Ild
 3SAwdBIQEzpbFPme1ahqmoeaoY2AI0EUwEyCl63lHr8FJiTHzGHNbhHt6HGK9WU5q2ub
 iIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=bWILoTj9JA6Tmk0XrQauVIYwOVRzoTVZU/UwHFJ7pGk=;
 b=Wve5t9Gp/G4WqIvvQTt6g3971vgC/rDQJcMwQnrm2MXTeM7d96x7kmaEfgw4j4OhFV
 cezn3/X6x9XKG5LM5Q4CMwEuVrzcvAYdbHA86danvIrabZnU1lk6rsGKSIrIUgdVA+G6
 T3YVAXYMwJP3ZSVmVzCu06PoVNw7KkRCPy7AkJRRm/z9paThaoTjWwC+MuZOuteEDyv4
 XDGvP+2pIREPs4nh3CCg3H2vlERSukVhCU72M+Yc4rzOIbx4445opfCMci0N5tvnt6o6
 JH+JgSGy0I2aCByb3OpRvRUUJiFMKGNRj9s9iFlgDdga1QCT1crdPo4aniPO3lRhCzQd
 pSsA==
X-Gm-Message-State: APjAAAXmiygNFgvdlRHX5UepaEv578g0Bk1FPO3SWF3Ih/HpGZG9nq1U
 CKEK6RHO++X4JDLKRplsJvlXa9TvxtNVfvPaPKHFTw==
X-Google-Smtp-Source: APXvYqw1Mub6vDZaoaPiPXCdJV+1+Dh2UUp3xdRsMsXaz0FmfSYgWiMpI04g0IGulCGmG2bfHODrMvQEUlZBdNyuhRo=
X-Received: by 2002:a9d:6014:: with SMTP id h20mr12356224otj.207.1569005322523; 
 Fri, 20 Sep 2019 11:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <156893679671.13979.11441470387200549191.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <156893679671.13979.11441470387200549191.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Sep 2019 11:48:31 -0700
Message-ID: <CAPcyv4gb+tPAxqfPx7EWH=4QRsgG00yp3avDWrLtsm4udLXrxg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: prevent nvdimm from requesting key when
 security is disabled
To: Dave Jiang <dave.jiang@intel.com>
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
Cc: jthumshirn@suse.com, peter.stark@ts.fujitsu.com,
 linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Thu, Sep 19, 2019 at 4:46 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Current implementation attempts to request keys from the keyring even when
> security is not enabled. Change behavior so when security is disabled it
> will skip key request.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Patch looks good, but lets also include some details of the failure
mode this causes so others can track if this issue is impacting them.
A "Fixes:" and "Cc: <stable@...>" tag also seem appropriate.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

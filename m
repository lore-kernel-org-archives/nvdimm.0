Return-Path: <SRS0=RHvU=FT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA78BC4361B
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FD822343E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FD822343E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 315D9100EF26A;
	Tue, 15 Dec 2020 15:21:58 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::542; helo=mail-ed1-x542.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 837DB100EF264
	for <linux-nvdimm@lists.01.org>; Tue, 15 Dec 2020 15:21:54 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id j16so441784edr.0
        for <linux-nvdimm@lists.01.org>; Tue, 15 Dec 2020 15:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XkTD7GQN+uGdH2WnGLwH7JSAaVZBYUF464p0d6QBzOE=;
        b=XI8dT1y9XKoJ3R8t3RgXQdVPPYdbN8KWPMrCp1r7Fsm9nTI0cZQYDMRXn/Y607wVFG
         ZSCJMzJV7VUPU72KAEtNsYiUQ2lPLGsYaHNwMT8nLe5nFQg8hVc7GsnSiQfyKVBDiguY
         Rys3aPelpbm0S9cI3gUsm3+oGD9u4uulddiEfLmzYiw1fAbVacONAYKO8rsRB3vkqy7b
         UOVxHhjNu4RooyAkPdxkDsToKnIT1DV9AWyKFsEF4vd9iLl9so4UAKah5D4wwHiPx7Th
         XQtilf+N2karT9hOdEWvPc7LivrhgV5VYoI5t4h2FjYk6X0L4b9jCUgxaqDbxlmV8mWX
         zeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XkTD7GQN+uGdH2WnGLwH7JSAaVZBYUF464p0d6QBzOE=;
        b=g6Ny8dxOi+h35zld+9LKutyKMSvCZmPIuF+mqrIIUChGw8SXoYJEGV/uzkg0HXVwDQ
         YnQZ/v1WiTFyxR+ffkbWXkcQc3x+1kgvcWgSY2o0J06CxMwB+nuxB3M0TxTigls7upuL
         700keq6pigD0cRVZK102lhddBvBOxSMpS/QxmGLTpgCYBEMW+9K2hKazU/NwNxRg9THz
         ZX3Muk/sZmF5sOaroD0fffOPbOZYLNzH1SRXE4WGbUS2xHwuXweUdbJwXKD/2g1P6uYD
         BGKjqu8Z+fCoIZX+zTo2Sc6lYOeouTsdaAWtYC5I9aVnhBXQOiaPhaboSkenYvgbc6L3
         /SeA==
X-Gm-Message-State: AOAM533c9ABwbz/vNjlfZ8AiDlSufFxN+vpBwaBf6tIN11TkGePDz63a
	75pk6zJrpQRhx+fYdDX3kb0RUauhpdlRJghDUUd9AA==
X-Google-Smtp-Source: ABdhPJwE2C00RYSRQ0ohD1M+QCM/7EWKEp/33KFGlbeW20ZvJJ5bCj0OTSiVlMp8313zJKsDIca11g5dT4VbxU/e3tM=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr4343534edw.52.1608074512617;
 Tue, 15 Dec 2020 15:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20201214103859.2409175-1-santosh@fossix.org>
In-Reply-To: <20201214103859.2409175-1-santosh@fossix.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Dec 2020 15:21:40 -0800
Message-ID: <CAPcyv4iDGN8Z=uXHrgo8Zs=Br6xbsmZsJ6VAcQVZXd=d9Nkoew@mail.gmail.com>
Subject: Re: [RFC v5 0/7] PMEM device emulation without nfit depenency
To: Santosh Sivaraj <santosh@fossix.org>
Message-ID-Hash: I7YAVXNIXBN5LTOU6HYR4WRI57EAMQ6X
X-Message-ID-Hash: I7YAVXNIXBN5LTOU6HYR4WRI57EAMQ6X
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Linux NVDIMM <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, Harish Sriram <harish@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/I7YAVXNIXBN5LTOU6HYR4WRI57EAMQ6X/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Typically RFC means "not ready to apply, still seeking fundamental
approach feedback". Should I be looking to consider this for
v5.11-rc1, or is this still RFC / should wait for v5.12?

On Mon, Dec 14, 2020 at 2:39 AM Santosh Sivaraj <santosh@fossix.org> wrote:
>
> The current test module cannot be used for testing platforms (make check)
> that do not have support for NFIT. In order to get the ndctl tests working,
> we need a module which can emulate NVDIMM devices without relying on
> ACPI/NFIT.
>
> The emulated PMEM device is made part of the PAPR family.
>
> Corresponding changes for ndctl is also required, to add attributes needed
> for the test, which will be sent as a reply to this patch.
>
> The following is the test result, run on a x86 guest:
>
> PASS: libndctl
> PASS: dsm-fail
> PASS: dpa-alloc
> PASS: parent-uuid
> PASS: multi-pmem
> PASS: create.sh
> FAIL: clear.sh
> FAIL: pmem-errors.sh
> FAIL: daxdev-errors.sh
> PASS: multi-dax.sh
> PASS: btt-check.sh
> FAIL: label-compat.sh
> PASS: blk-exhaust.sh
> PASS: sector-mode.sh
> FAIL: inject-error.sh
> SKIP: btt-errors.sh
> PASS: hugetlb
> PASS: btt-pad-compat.sh
> SKIP: firmware-update.sh
> FAIL: ack-shutdown-count-set
> PASS: rescan-partitions.sh
> FAIL: inject-smart.sh
> FAIL: monitor.sh
> PASS: max_available_extent_ns.sh
> FAIL: pfn-meta-errors.sh
> PASS: track-uuid.sh
> ============================================================================
> Testsuite summary for ndctl 70.10.g7ecd11c
> ============================================================================
> # TOTAL: 26
> # PASS:  15
> # SKIP:  2
> # XFAIL: 0
> # FAIL:  9
> # XPASS: 0
> # ERROR: 0
>
> The following is the test result from a PowerPC 64 guest.
>
> PASS: libndctl
> PASS: dsm-fail
> PASS: dpa-alloc
> PASS: parent-uuid
> PASS: multi-pmem
> PASS: create.sh
> FAIL: clear.sh
> FAIL: pmem-errors.sh
> FAIL: daxdev-errors.sh
> PASS: multi-dax.sh
> PASS: btt-check.sh
> FAIL: label-compat.sh
> PASS: blk-exhaust.sh
> PASS: sector-mode.sh
> FAIL: inject-error.sh
> SKIP: btt-errors.sh
> SKIP: hugetlb
> PASS: btt-pad-compat.sh
> SKIP: firmware-update.sh
> FAIL: ack-shutdown-count-set
> PASS: rescan-partitions.sh
> FAIL: inject-smart.sh
> FAIL: monitor.sh
> PASS: max_available_extent_ns.sh
> FAIL: pfn-meta-errors.sh
> PASS: track-uuid.sh
> ============================================================================
> Testsuite summary for ndctl 70.git94a00679
> ============================================================================
> # TOTAL: 26
> # PASS:  14
> # SKIP:  3
> # XFAIL: 0
> # FAIL:  9
> # XPASS: 0
> # ERROR: 0

With these run reports are you trying to demonstrate the improvement,
or the future work?

I think it's sufficient to say that no tests ran with nfit_test
previously, but now 26 pass. Extra interesting would be to determine
if any current papr regression fixes in the tree would have been
caught by an ndtest run.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

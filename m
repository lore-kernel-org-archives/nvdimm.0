Return-Path: <SRS0=O2lA=FD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21892C3E8C5
	for <linux-nvdimm@archiver.kernel.org>; Sun, 29 Nov 2020 04:36:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 708D9206F1
	for <linux-nvdimm@archiver.kernel.org>; Sun, 29 Nov 2020 04:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kA3r44LV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 708D9206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 12180100EC1EB;
	Sat, 28 Nov 2020 20:36:42 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::22c; helo=mail-oi1-x22c.google.com; envelope-from=enbyamy@gmail.com; receiver=<UNKNOWN> 
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 45892100EC1E6
	for <linux-nvdimm@lists.01.org>; Sat, 28 Nov 2020 20:36:39 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id w15so10514730oie.13
        for <linux-nvdimm@lists.01.org>; Sat, 28 Nov 2020 20:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qSqgo0diyYMJnfVubSHu3iSrO3muNitTzdW7zZJSstQ=;
        b=kA3r44LVTktioEzHeiRWWGwvEf0M1uIP0nJuH79y7vofVPbZWcxbCgP/gmSxe0j6sv
         vufcbAz3I85uEHvcENyNBibPfiDskvZN1CZzKuUaPR328682T2PqdBQxociWg1ApzkRE
         N2OHNua41q29TDmrnVVhqVoP3a4vPLr9D2r1a/Q3jS8ocl5h9PIbbif/FTVUiqcVfjhs
         4AIC8JelpZ+I3LVCDM3ua+gAXGVcf2keOAbfI7JuXV6TIYUgWvbh7hu8bWUPILwHATzX
         W/O5YlkKUVWYzSh3R5yUcFogYmBdrDeswwzbqvvhFwNBXLZ0bKUdqbXEgX9t1A7G7369
         Q/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qSqgo0diyYMJnfVubSHu3iSrO3muNitTzdW7zZJSstQ=;
        b=MDenjjJiPIOeTZu5XR8ucsNM8Si85kzsdPmsC5OhtYiwXGJhccE7RILK5A1ACB+6gz
         XMqpWypKC+5vNAFkQN4B08hXfhY9bjD0YmtX9tOWvNU1Xqp0gXeWJyKCSyle8yR76ZZA
         Yi7LwYQWn/aYeuEAC7sIXaBHPd7va98fhr3i88pvz7L8w8ke3DIiC8cd2Xoa90mHqheR
         gUYlelJ0ZwA+J/hc2wUIC5HDRO6g42d7wS2AQb6sBeK9jrgNyfKhY6Y7fWcefaE3b77S
         TH9s6XY3scgiJdBatFeoHb1OPl3C50GI8mlbjRWN4RYKpxQN2D47WHwroIi7DXC97ClB
         RmiA==
X-Gm-Message-State: AOAM5328/PdBYtzc3eIwlLBabPb8wiGxEMgjGBlHYMnBWnuGseZHHcOl
	n0j2ewKi5S1JAavC1BFfBeNQZNrTTLolRmfJy0Y=
X-Google-Smtp-Source: ABdhPJwI3MDqaIvldfOztxCm4put73JY3SkoxT3AVGSEax90AoUZKDzuYGnT4bif/+FGWuSsNnY5biAOoaQAFlmOKE8=
X-Received: by 2002:a05:6808:3b1:: with SMTP id n17mr10712069oie.139.1606624597578;
 Sat, 28 Nov 2020 20:36:37 -0800 (PST)
MIME-Version: 1.0
From: Amy Parker <enbyamy@gmail.com>
Date: Sat, 28 Nov 2020 20:36:27 -0800
Message-ID: <CAE1WUT4XUmTz89cFf3eT4OFXRwgxwdre21KnAMJKcQ_iqzicQw@mail.gmail.com>
Subject: [PATCH 0/3] Migrate zero page DAX bit from DAX_ZERO_PAGE to XA_ZERO_ENTRY
To: dan.j.williams@intel.com, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
Message-ID-Hash: R6QXL54SC4UQZI5GXL32SD4ZMY4XI3LG
X-Message-ID-Hash: R6QXL54SC4UQZI5GXL32SD4ZMY4XI3LG
X-MailFrom: enbyamy@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/R6QXL54SC4UQZI5GXL32SD4ZMY4XI3LG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset changes the representation in the NVDIMM DAX driver for a hole
in a file. It was previously represented by DAX_ZERO_PAGE, which was set as
1UL << 2.

Patch 1 migrates to XArray's XA_ZERO_ENTRY and registers the new
definition for XA_ZERO_PMD_ENTRY, which is used in dax_pmd_load_hole() to
represent whether a file is a PMD entry or a zero entry. Patch 2 shifts
the bit for DAX_EMPTY down from 1UL << 3 to 1UL << 2, as DAX_ZERO_ENTRY no
longer exists. Patch 3 corrects the terminology used above the definitions
for the DAX bits.

I tested this under xfstests with XFS+DAX for a 20 GiB NVDIMM and did not
observe any regressions.

Amy Parker (3):
 fs: dax.c: move fs hole signifier from DAX_ZERO_PAGE to XA_ZERO_ENTRY
 fs: dax.c: move down bit DAX_EMPTY
 fs: dax.c: correct terminology used in DAX bit definitions

 fs/dax.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)


--
2.29.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

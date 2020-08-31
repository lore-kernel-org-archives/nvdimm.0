Return-Path: <SRS0=Plg1=CJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DE6C433E2
	for <linux-nvdimm@archiver.kernel.org>; Mon, 31 Aug 2020 00:10:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6EE52076D
	for <linux-nvdimm@archiver.kernel.org>; Mon, 31 Aug 2020 00:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSbrDwsJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6EE52076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 66C5913952FF1;
	Sun, 30 Aug 2020 17:10:56 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::c43; helo=mail-oo1-xc43.google.com; envelope-from=richmondwilliamsrozay@gmail.com; receiver=<UNKNOWN> 
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 090DF139416AB
	for <linux-nvdimm@lists.01.org>; Sun, 30 Aug 2020 17:10:50 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id r6so1040047oon.13
        for <linux-nvdimm@lists.01.org>; Sun, 30 Aug 2020 17:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zKdL6qTnxETV17GJUdUkXemWyj/J+k3++iUEJWuERNE=;
        b=VSbrDwsJqmKd9IM212MvqylYI6ezX04rOQdsLgg0J4amyC1MWaQm+yHnDtKwFKLqJX
         Vi9Gos+CCRTkdO5N9vzOqOpqDDqLnkYxjEQcBuWQh/oFw/jCj4AXO/GUdfVt7xC8VVMe
         MtpJinITXHVwQAOdd09TmdO1pzR3kUqSFFPSenEI99Yrh+xX9K6YZjO8GXXFsyRc/MR7
         V8OrYwnZjEnz50ofqrbAFyhD+zl1mcIg/BLDgemqsLNKUqhNY1pXBo8Kep1OboXnkJIh
         b2uY6r9ob4cOC0siE02P/KrAnJeCBnjWKSKDkqu+cnNzEVXaap6trUlwrM/ho8AZgIt9
         g0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zKdL6qTnxETV17GJUdUkXemWyj/J+k3++iUEJWuERNE=;
        b=pItsFRDO2Joj0dOpmH8T6HfBWihbt82Q+wGxtwEtS3NTkCuMlfZnUL1aEpTQcnKhVI
         fJ8R4gWhXKy9OtxT0oWokk//z5DwevmcjJ4Q1n1pRxmRTCJpJ2kqFsW/mhuf/dwJhETk
         1/oYy2XbBwq25w/tV3R0W2L22TQX8Eqf14c5c+HhM7FKs5+/+MUsdevoxmS53c9KvK/b
         bG/Jw3iOZuKoBw3mgj4d1HV9x0CqXaYjhl7YpH9XuWdqGRkVtsTzZ108Ehe1kbywQpJc
         UPIoUdo1iVJANeTyUIPOfu2fKZGoo9+LuV8qPoXtorMDpybOUTFJhtyf0hEUXu/CAB10
         MI1Q==
X-Gm-Message-State: AOAM531frb1mP577alVUgUcgPrZ6Lj13Q5ogVfGqURcBgi8YWopV9zHc
	tLsw+tndxFJdU4LWpaEVpacT41skXBxbmjiR+2o=
X-Google-Smtp-Source: ABdhPJyBeTlgTY9VIulv7WbP+B1mml/2CpdcOlo8lLlxBzrscv+UuaV2VLFav5Nw8MtCmXk/wRayb9Z//rkeTfvhe4c=
X-Received: by 2002:a4a:aec3:: with SMTP id v3mr6112951oon.69.1598832649471;
 Sun, 30 Aug 2020 17:10:49 -0700 (PDT)
MIME-Version: 1.0
From: charlotte wilson <wilsoncharlotte794@gmail.com>
Date: Mon, 31 Aug 2020 02:10:56 +0200
Message-ID: <CAF9u52zL_zGzVC5CMHEOtOUkO47_5Du_M3grO+rSfRgD3oLSrw@mail.gmail.com>
Subject: urgent
To: amirycashforcars@gmail.com, bpcornerstone@gmail.com, 90guna@gmail.com,
	mcg.inmobiliaria18@gmail.com, Logywonzy@gmail.com, marcelodis1969@gmail.com,
	cantonunitedmethodist@gmail.com, onthebrain@gmail.com,
	Williams.Gonzelesx79638@gmail.com, skatemd.healinghearts@gmail.com,
	suoseura49@gmail.com, richardwilliams60941@gmail.com, teresastang3@gmail.com,
	pali.rohar@gmail.com, dan.j.williams@intel.com, linux-nvdimm@lists.01.org,
	liu21st@gmail.com, davidedb@gmail.com, techpulselimited@gmail.com,
	rentahousepuntapacifica@gmail.com, abpsa_tradeunion@yahoo.com,
	clairmontelynch@gmail.com, orenjardine@yahoo.ca, liyeplimal@gmail.com,
	Dr.mohammed.alaradi.85@gmail.com, kcbhatch@gmail.com, mgems118@gmail.com,
	riafinancialsolution@gmail.com, thelillianschool@gmail.com,
	pcd-dam@saite.com.sa, closanaruiz@gmail.com, lakmohammed2@gmail.com,
	shahidhassan.mohammed@gmail.com, jamal.hassan@pilgroup.com,
	zeyad.alkhodani@pilgroup.com, mohammed.alhamdi@gasigl.com,
	boubacar.ba@pilgroup.com, aadithmotorshunsur@gmail.com, falconec@candw.ag,
	abhisheknerkar007@gmail.com, chris.honcik@gmail.com,
	ben.mohammed@onezerocairnscity.com.au, loveastrologersharafatali@gmail.com,
	curatorialschool@gmail.com, Patharkar.ss@gmail.com, alishahanshah@gmail.com,
	millienniumlaser@gmail.com, biswasranjit1956@gmail.com,
	italconsulmiami@gmail.com, awpakwan@gmail.com
Message-ID-Hash: JQXJUMRZOYHV6TSYQA2UGQVTPMH4AVZM
X-Message-ID-Hash: JQXJUMRZOYHV6TSYQA2UGQVTPMH4AVZM
X-MailFrom: richmondwilliamsrozay@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/JQXJUMRZOYHV6TSYQA2UGQVTPMH4AVZM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 How are you? Mrs. Wilson, from Australia, do you receive my previous
message? Contact me in return. Very urgent.
Greetings,
Charlotte Wilson
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

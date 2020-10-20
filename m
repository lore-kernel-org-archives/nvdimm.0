Return-Path: <SRS0=Pj+/=D3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.6 required=3.0 tests=ADVANCE_FEE_5_NEW_MONEY,
	BAYES_50,DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,
	HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_MONEY_PERCENT,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E738C388F9
	for <linux-nvdimm@archiver.kernel.org>; Tue, 20 Oct 2020 14:17:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D0E12098B
	for <linux-nvdimm@archiver.kernel.org>; Tue, 20 Oct 2020 14:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q2gjOYCb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D0E12098B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8DCD215F6580D;
	Tue, 20 Oct 2020 07:16:57 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::f47; helo=mail-qv1-xf47.google.com; envelope-from=3u_goxxijdhqxstawffw.lsyjgustyyesad.ugedafmp-fnvaeedaklk.st.gjy@trix.bounces.google.com; receiver=<UNKNOWN> 
Received: from mail-qv1-xf47.google.com (mail-qv1-xf47.google.com [IPv6:2607:f8b0:4864:20::f47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A155F15F4DB02
	for <linux-nvdimm@lists.01.org>; Tue, 20 Oct 2020 07:16:53 -0700 (PDT)
Received: by mail-qv1-xf47.google.com with SMTP id ec4so1424757qvb.21
        for <linux-nvdimm@lists.01.org>; Tue, 20 Oct 2020 07:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:message-id:date:subject:from:to;
        bh=COWyHY820vwEwRi9c9JvW7D7pzg5THP+7V9JbzOmiWk=;
        b=q2gjOYCbnd6GyxlJEJ/cGBlTt72iyhaWGh8KTAaaSS3TB94MtT1V8rL8tK3BIYrQv5
         2EmWhAEyJcXPN1KqPDQ1uYhFvClvGARJBbZ1+zk/eFNPU+Ozi/edd+Y/G+zjfg5S3apk
         xoP0VCwECCIkV3DREfBaGLTC/6QvtWTzawP5MW1/Swd4/Dlama31QhQ6K+sQqWUknDqU
         9XyFofbOELegzeag1dQFJEB6bo5kGjtV7yKDjeVrvFCf9riKgCFgGU06QLN7FCtenJcg
         vLWtfnX0IgPjoMiGmctmAvOB65XeLqFkE/NRezYtoUCp2SAk1oQavALAEimi5JTdR/FR
         R98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:message-id:date:subject
         :from:to;
        bh=COWyHY820vwEwRi9c9JvW7D7pzg5THP+7V9JbzOmiWk=;
        b=eAYdtgQBBFhTmGB6cg6MHt2O8UnTlwk27URS9ukrEvsuhPg2AtHb8wTl33x7i8Masm
         UzGtqnw0Fh6c+2bqrAPZjlhFxhGlakJikUrqC+Sj9waILrwMo6xE7EjS2Lf6ZA+uQZQp
         NWNCFVkmO+7qWgdF/DtEsNObcuFK174MBgmtN6L6u1Fjv0Z/lcnSM/1P4k6mAMUcBEiP
         Ty8ewoOYlgcoVnzV8Wo6Us5gI+yx37TATmfGEG0GzEV0cCXcHRPUuuZ2gEOTevj8CKHM
         Cp22ze3niMsUMTpSzURDHVvMiOwv5Pkc5fRqk8CMzX0T+sFCKQhNca9heOlNO57d525T
         5Tnw==
X-Gm-Message-State: AOAM530+X1DKSPswpdB4ElOagus7rbjmt7CxtyYkW0vMnV88+rXbf3Iq
	6Gj9cxwVEXi20eYDOLVnwd1lr4iL2WXNv9ByZ2eg
MIME-Version: 1.0
X-Received: by 2002:a05:622a:1c4:: with SMTP id t4mt3177955qtw.147.1603203411022;
 Tue, 20 Oct 2020 07:16:51 -0700 (PDT)
X-No-Auto-Attachment: 1
Message-ID: <000000000000d11c9205b21ae113@google.com>
Date: Tue, 20 Oct 2020 14:16:52 +0000
Subject: From Miss Nidal Aoussa.
From: fabienne.tagro2016@gmail.com
To: linux-nvdimm@lists.01.org
Message-ID-Hash: PI3FILOKAWNOSPPW4VYLUSWX4T7APK5Z
X-Message-ID-Hash: PI3FILOKAWNOSPPW4VYLUSWX4T7APK5Z
X-MailFrom: 3U_GOXxIJDHQXSTaWffW.lSYjgustyYeSad.Ugedafmp-fnVaeedaklk.st.gjY@trix.bounces.google.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: fabienne.tagro2016@gmail.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PI3FILOKAWNOSPPW4VYLUSWX4T7APK5Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit

I've invited you to fill out the following form:
Untitled form

To fill it out, visit:
https://docs.google.com/forms/d/e/1FAIpQLSeQIj2QpMXgQbMEcEv3RJXvlfCdBYxn9Y22RoTGN5DS88sjBw/viewform?vc=0&amp;c=0&amp;w=1&amp;flr=0&amp;usp=mail_form_link

Hello Dear,

I am very sorry that my letter may come as a surprise to you since we have  
never met each other before. I am Miss Nidal Aoussa. I am the only daughter  
of Cheikh Ag Aoussa, the President of (HCUA) in Mali who was assasinated on  
the octobre 2016.

https://www.jeuneafrique.com/365432/politique/mali-sait-on-mort-de-cheikh-ag-aoussa/
https://fr.wikipedia.org/wiki/Cheikh_Ag_Aoussa

I have a business transaction which i solicit your help. It is all about a  
fund to be transferred in your country for urgent investment on important  
projects. I want you to guide me and invest this money in your country.  
This fund amount to Eleven Millions Five Hundred Thousand United States  
dollars which i inherited from my late dad.. If you are capable of handling  
or participate in this transaction, kindly respond quickly through my  
private emails to enable me give you more details about this fund and how  
this project shall be carried out. I will accord you 20% of the total fund  
for your kind assistance. Respond through this my private emails addresses  
below.

Miss Nidal Aoussa
Email: ( nidal.kong2020@gmail.com )

Google Forms: Create and analyze surveys.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

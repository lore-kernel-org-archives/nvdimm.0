Return-Path: <SRS0=HWW4=BJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE88C433DF
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Jul 2020 19:58:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B177220829
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Jul 2020 19:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJycIDfO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B177220829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id AF777127A469A;
	Thu, 30 Jul 2020 12:58:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=jhoanaradanas@gmail.com; receiver=<UNKNOWN> 
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id AA42D127A4697
	for <linux-nvdimm@lists.01.org>; Thu, 30 Jul 2020 12:58:49 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 184so7314341wmb.0
        for <linux-nvdimm@lists.01.org>; Thu, 30 Jul 2020 12:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=29XMM2S6wtHfnn1fZ9Nz+oYd0F7YPFugPt0rV5vMimI=;
        b=lJycIDfOiUdryYwwRvh83GH8BxFmf5K9oQVjLZH1mWKY9vGFtbZtgYTacQw0RN7Ea6
         9CqbhMkksOFqIy+Nh6R79XDqCT6Ou2LJiiddhWmdCJombAZLJA3g3HJ5kli2SfJZomBz
         gCh4J4/YC2L3wYGF87qaB0d3C86MgxZer6tLtUhft9elt+7IusXjJkGMs79XTdOxz7kj
         dz7u4CW48NDOPxQ2N2mtIOJDlHlxonLLVoEtQqc3pWP5uG+vH/63eQaXSSH3lnlh9Iq0
         2ihNBfi8EWOsWk1cVqwO01NHeAKdo+7y0BViZAK9NTDSojLEOXeI9GvZbeS4+NJeOHMs
         AAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=29XMM2S6wtHfnn1fZ9Nz+oYd0F7YPFugPt0rV5vMimI=;
        b=T/ProK8Nl0zFzsnUmsFeSeijiE/Yp+yTs9d9AyoY3MvzTwd/iYNgO9PXBsvHe32WnF
         T0KeCPZgSFjcOmrcSNLrMwrd34S8rqhkbWwIbbc8L2KGXItYhXqauZXpsOF5VnF5F64T
         JLmBV6wOdqQE+GWi9xhpEDdcsFNuP3SiIU1pGr9e63Vqv3FEoWMM49No2VLq3YR+e/Hj
         JYhRvd94w6zHxhHXPlDcaUDmZhy7zFxEFafBDhdKKx9dCfL/0K83Q7U1ZCmBJH58pWwx
         qQODhCIIMP32jgweo2eLSOOORbUu3OR8tJkK+ncbQD5i9Xy4I0j2kcbawihII5SXJYrn
         zyIQ==
X-Gm-Message-State: AOAM531vn44C8Dug5N0+/OvP3uCzSNPpCr6yFjiGciDdXmzfvwqIlvl4
	mbOiLeSypKNi7zrsA3qDzkx1nhYbe9AHERKVQNWL+Q==
X-Google-Smtp-Source: ABdhPJxiMZJx7Cd4PLlvBWyFMoh8zUFRIn/zhOp1gdBe9/GrBn7Y3Yf/0QxBtM1Wa48nEx1tEDpu4mW7TVvgjMMl7SY=
X-Received: by 2002:a7b:c306:: with SMTP id k6mr758846wmj.86.1596139127758;
 Thu, 30 Jul 2020 12:58:47 -0700 (PDT)
MIME-Version: 1.0
From: Jhoan Aradanas <jhoanaradanas@gmail.com>
Date: Fri, 31 Jul 2020 03:58:34 +0800
Message-ID: <CAMvTTZp9t+gDrB5bU433R85j_WBD4SxFfa-C1-B_sr+OZHFv_g@mail.gmail.com>
Subject: Re: MY LOVE,
To: linux-nvdimm@lists.01.org
Message-ID-Hash: QYQA5TI5NT2YH34KEVUNYKMQTOLPWZCJ
X-Message-ID-Hash: QYQA5TI5NT2YH34KEVUNYKMQTOLPWZCJ
X-MailFrom: jhoanaradanas@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QYQA5TI5NT2YH34KEVUNYKMQTOLPWZCJ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Lina Williams this is my love.  Where are u from.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

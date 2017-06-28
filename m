Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from muon.cran.org.uk (muon.bluestop.org [74.50.51.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 105E721A00AEB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 08:38:55 -0700 (PDT)
Received: from muon.bluestop.org (localhost [127.0.0.1])
 by muon.cran.org.uk (Postfix) with ESMTP id 0C5833CFCE
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 15:40:26 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
 by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id bG1iQFM37s_D for <linux-nvdimm@lists.01.org>;
 Wed, 28 Jun 2017 15:40:25 +0000 (UTC)
Received: from localhost (c-73-20-20-155.hsd1.ut.comcast.net [73.20.20.155])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by muon.cran.org.uk (Postfix) with ESMTPSA
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 15:40:25 +0000 (UTC)
Date: Wed, 28 Jun 2017 09:40:25 -0600
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Standardization of ACPI NVDIMM DSMs
Message-ID: <20170628094025.00001fc0@bluestop.org>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

I'm pretty new to ACPI work so it's possibly I'm misunderstanding
something. I've recently started working on NVDIMMs, and have
noticed that both HPE and Intel have DSM "Example" interfaces that are
referenced/used in Linux. I've been wondering if there's a reason
the content from both couldn't be combined and added to the ACPI
specification with sufficient vendor-specific fields to support the
cases where they need to differ?

-- 
Rebecca Cran
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

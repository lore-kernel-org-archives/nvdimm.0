Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22a.google.com (mail-wm0-x22a.google.com
 [IPv6:2a00:1450:400c:c09::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 050F020958BF5
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 15:26:23 -0700 (PDT)
Received: by mail-wm0-x22a.google.com with SMTP id g206so2587079wme.0
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 15:29:28 -0700 (PDT)
MIME-Version: 1.0
From: Brian Stark <brian.stark@sanmina.com>
Date: Tue, 19 Sep 2017 15:29:24 -0700
Message-ID: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
Subject: Access to NVDIMM JEDEC registers
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

Where can I find documentation on accessing NVDIMM JEDEC registers, for
example if I want to read page 0 offset 0x80 (defined to be CSAVE_INFO in
the JEDEC specification.  How do I do this through Linux given that the
BIOS has locked the chipset?

Brian

-- 
CONFIDENTIALITY
This e-mail message and any attachments thereto, is intended only for use 
by the addressee(s) named herein and may contain legally privileged and/or 
confidential information. If you are not the intended recipient of this 
e-mail message, you are hereby notified that any dissemination, 
distribution or copying of this e-mail message, and any attachments 
thereto, is strictly prohibited. If you have received this e-mail message 
in error, please immediately notify the sender and permanently delete the 
original and any copies of this email and any prints thereof.
ABSENT AN EXPRESS STATEMENT TO THE CONTRARY HEREINABOVE, THIS E-MAIL IS NOT 
INTENDED AS A SUBSTITUTE FOR A WRITING. Notwithstanding the Uniform 
Electronic Transactions Act or the applicability of any other law of 
similar substance and effect, absent an express statement to the contrary 
hereinabove, this e-mail message its contents, and any attachments hereto 
are not intended to represent an offer or acceptance to enter into a 
contract and are not otherwise intended to bind the sender, Sanmina 
Corporation (or any of its subsidiaries), or any other person or entity.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

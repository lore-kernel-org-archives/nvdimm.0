Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x233.google.com (mail-wr0-x233.google.com
 [IPv6:2a00:1450:400c:c0c::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BB8721EBD1A8
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 16:12:58 -0700 (PDT)
Received: by mail-wr0-x233.google.com with SMTP id s18-v6so18148226wrg.9
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 16:12:58 -0700 (PDT)
MIME-Version: 1.0
From: Brian Stark <brian.stark@sanmina.com>
Date: Thu, 19 Apr 2018 16:12:56 -0700
Message-ID: <CAKccVayU9NW6gWao=w-h3aZaRrCW-=-J7he0hVeWjBA+hjhJ=g@mail.gmail.com>
Subject: Write through caching on NVDIMM
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

I was comparing different caching techniques using MTRR entries and I
found something strange.  Note the output is from a basic utility that
uses mmap.

NV Memory:

Write-back

Writes took 2075.993408 Megabytes per second
Reads took 2130.842529 Megabytes per second No Errors Found

Write-Through

Writes took 55.332256 Megabytes per second
Reads took 92.310310 Megabytes per second No Errors Found  !!!I was
expecting this number to be the same as Write-back

Uncached

Writes took 55.331089 Megabytes per second
Reads took 92.315132 Megabytes per second No Errors Found

Regular memory:

Write-back

Writes took 1875.560791 Megabytes per second
Reads took 2070.452637 Megabytes per second No Errors Found

Write-Through

Writes took 54.903713 Megabytes per second
Reads took 2106.244629 Megabytes per second No Errors Found  !!!This
is what I expected to see for NV Memory

Uncached

Writes took 54.903923 Megabytes per second
Reads took 90.150986 Megabytes per second No Errors Found

I am using the same driver (which adds MTRR entries to change caching
type) there is no physical reason why write through should behave
differently when using NV Memory.  Does anybody on this mailing list
who may be more familiar with caching techniques know why this might
me the case?

Brian

-- 
CONFIDENTIALITY
This e-mail message and any attachments thereto, is 
intended only for use by the addressee(s) named herein and may contain 
legally privileged and/or confidential information. If you are not the 
intended recipient of this e-mail message, you are hereby notified that any 
dissemination, distribution or copying of this e-mail message, and any 
attachments thereto, is strictly prohibited.  If you have received this 
e-mail message in error, please immediately notify the sender and 
permanently delete the original and any copies of this email and any prints 
thereof.
ABSENT AN EXPRESS STATEMENT TO THE CONTRARY HEREINABOVE, THIS 
E-MAIL IS NOT INTENDED AS A SUBSTITUTE FOR A WRITING.  Notwithstanding the 
Uniform Electronic Transactions Act or the applicability of any other law 
of similar substance and effect, absent an express statement to the 
contrary hereinabove, this e-mail message its contents, and any attachments 
hereto are not intended to represent an offer or acceptance to enter into a 
contract and are not otherwise intended to bind the sender, Sanmina 
Corporation (or any of its subsidiaries), or any other person or entity.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

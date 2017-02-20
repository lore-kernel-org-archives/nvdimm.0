Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtpauth1.wiscmail.wisc.edu (wmauth1.doit.wisc.edu
 [144.92.197.141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12F1D82137
 for <linux-nvdimm@lists.01.org>; Sun, 19 Feb 2017 22:25:25 -0800 (PST)
MIME-version: 1.0
Received: from avs-daemon.smtpauth1.wiscmail.wisc.edu by
 smtpauth1.wiscmail.wisc.edu
 (Oracle Communications Messaging Server 8.0.1.1.0 64bit (built Jun 15 2016))
 id <0OLN00G00TAFUL00@smtpauth1.wiscmail.wisc.edu> for
 linux-nvdimm@lists.01.org; Mon, 20 Feb 2017 00:25:24 -0600 (CST)
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03lp0023.outbound.protection.outlook.com [207.46.163.23])
 by smtpauth1.wiscmail.wisc.edu
 (Oracle Communications Messaging Server 8.0.1.1.0 64bit (built Jun 15 2016))
 with ESMTPS id <0OLN00JU1TUBAJ20@smtpauth1.wiscmail.wisc.edu> for
 linux-nvdimm@lists.01.org; Mon, 20 Feb 2017 00:25:23 -0600 (CST)
Date: Mon, 20 Feb 2017 06:25:21 +0000
From: Sanketh Nalli <nalli@wisc.edu>
Subject: extent-status tree for DAX ?
Message-id: <BN3PR0601MB1429002E63AA4062331AF89DC85E0@BN3PR0601MB1429.namprd06.prod.outlook.com>
Content-language: en-US
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I was wondering if we need the extent-status tree

for DAX-like devices ? Says here that it can get consume a lot of memory
and offer poor performance if the on-DAX file is  fragmented. Without the status tree, one could simple walk the on-DAX extent tree to get to the file data pages and this is possible with DAX-like devices.


http://lxr.free-electrons.com/source/fs/ext4/extents_status.c#L117


A few simple experiments with filebench's random read workload clearly

bring out the difference in performance with a fragmented and contiguous

file on-DAX. A lot of time is spent in walking the status tree, which can be

avoided, I guess. Please let me know what you think.



--
S. Nalli
Graduate Student, Computer Sciences
University of Wisconsin-Madison, USA
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

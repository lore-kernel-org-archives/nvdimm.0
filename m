Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C44A20336AD4
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 05:45:40 -0700 (PDT)
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: [BUG] Injecting bad blocks in the nfit_test module does not work
 with kernel v4.17.4 + ndctl v61.1
Date: Wed, 4 Jul 2018 12:45:34 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEBF4F2E02E@IRSMSX101.ger.corp.intel.com>
Content-Language: en-US
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Li, ZhijianX" <zhijianx.li@intel.com>, Balcer,, Marcin
List-ID: <linux-nvdimm@lists.01.org>

Hi,

This is a bug report:  injecting bad blocks in the nfit_test module does not work with the kernel v4.17.4 (the latest stable at this moment) and ndctl v61.1:

# ndctl inject-error --block=11 --count=12 namespace0.0
# ndctl list -M
{
"dev":"namespace0.0",
"mode":"devdax",
"map":"dev",
"size":30412800,
"uuid":"610d117f-eb1c-4560-9934-283e4ab44c9a",
"raw_uuid":"2dcfe1c1-38b2-4d38-81fe-9ea6b035ddad",
"chardev":"dax0.0"
}

More details are available at this issue:
https://github.com/pmem/issues/issues/897

Regards,
Lukasz

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

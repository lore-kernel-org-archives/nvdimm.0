Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C0B821125463
 for <linux-nvdimm@lists.01.org>; Fri,  7 Sep 2018 14:23:21 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: open sets ext4_da_aops for DAX existing files
Date: Fri, 7 Sep 2018 21:23:19 +0000
Message-ID: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
Content-Language: en-US
Content-ID: <3C98B7BB7B0CDF4F9941A3B1A5DB8C6E@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

I noticed that both ext4_da_aops and ext4_dax_aops are used on DAX
mounted ext4 files.  Looking at open() path:

New file
--------
  lookup_open
    ext4_create
      __ext4_new_inode
        ext4_set_inode_flags   // Set S_DAX flag
      ext4_set_aops            // Set aops to ext4_dax_aops

Existing file
-------------
  lookup_open
    ext4_lookup
      ext4_iget
        ext4_set_aops          // Set aops to ext4_da_aops
        ext4_set_inode_flags   // Set S_DAX flag

So, we set ext4_da_aops for existing files since S_DAX flag is set after
ext4_set_aops().

Thanks,
-Toshi


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

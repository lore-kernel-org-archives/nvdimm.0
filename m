Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D14A221A0BABF
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 05:18:57 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v3] mm,dax: Fix data corruption due to mmap inconsistency
Date: Tue,  9 May 2017 14:18:33 +0200
Message-Id: <20170509121837.26153-1-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this series fixes data corruption that can happen for DAX mounts when
page faults race with write(2) and as a result page tables get out of sync
with block mappings in the filesystem and thus data seen through mmap is
different from data seen through read(2).

The series passes testing with t_mmap_stale test program from Ross and also
other mmap related tests on DAX filesystem.

Andrew, can you please merge these patches? Thanks!

Changes since v2:
* Added reviewed-by tag from Ross

Changes since v1:
* Improved performance of unmapping pages
* Changed fault locking to fix another write vs fault race

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A39D81A1E28
 for <linux-nvdimm@lists.01.org>; Thu, 27 Oct 2016 12:08:00 -0700 (PDT)
Date: Thu, 27 Oct 2016 21:07:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Infinite loop with DAX PMD faults
Message-ID: <20161027190750.GA28888@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

When testing my DAX patches rebased on top of Ross' DAX PMD series, I've
come across the following issue with generic/344 test from xfstests. The
test ends in an infinite fault loop when we fault index 0 over and over
again never finishing the fault. The problem is that we do a write fault
for index 0 when there is PMD for that index. So we enter wp_huge_pmd().
For whatever reason that returns VM_FAULT_FALLBACK so we continue to
handle_pte_fault(). There we do

	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))

check which is true - the PMD we have is pmd_trans_huge() - so we 'return
0' and that results in retrying the fault and all happens from the
beginning again.

It isn't quite obvious how to break that cycle to me. The comment before
pmd_none_or_trans_huge_or_clear_bad() goes to great lengths explaining
possible races when PMD is pmd_trans_huge() so it needs careful evaluation
what needs to be done for DAX. Ross, any idea?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-of-o51.zoho.com (sender-of-o51.zoho.com [135.84.80.216])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62083203BEA2E
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 22:08:58 -0700 (PDT)
In-Reply-To: <20180517050024.20101-1-ross.zwisler@linux.intel.com>
Subject: Re: [Qemu-devel] [qemu PATCH v2 0/4] support NFIT platform
 capabilities
Message-ID: <152653373366.258.12058788826462830143@1f70390a8372>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Wed, 16 May 2018 22:08:54 -0700 (PDT)
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: qemu-devel@nongnu.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
Resent-Message-Id: <20180517050900.144052063D745@ml01.01.org>
To: ross.zwisler@linux.intel.com
Cc: famz@redhat.com, ehabkost@redhat.com, linux-nvdimm@lists.01.org, mst@redhat.com, qemu-devel@nongnu.org, stefanha@redhat.com, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Hi,

This series seems to have some coding style problems. See output below for
more information:

Type: series
Message-id: 20180517050024.20101-1-ross.zwisler@linux.intel.com
Subject: [Qemu-devel] [qemu PATCH v2 0/4] support NFIT platform capabilities

=== TEST SCRIPT BEGIN ===
#!/bin/bash

BASE=base
n=1
total=$(git log --oneline $BASE.. | wc -l)
failed=0

git config --local diff.renamelimit 0
git config --local diff.renames True
git config --local diff.algorithm histogram

commits="$(git log --format=%H --reverse $BASE..)"
for c in $commits; do
    echo "Checking PATCH $n/$total: $(git log -n 1 --format=%s $c)..."
    if ! git show $c --format=email | ./scripts/checkpatch.pl --mailback -; then
        failed=1
        echo
    fi
    n=$((n+1))
done

exit $failed
=== TEST SCRIPT END ===

Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
>From https://github.com/patchew-project/qemu
 t [tag update]            patchew/1526517763-11108-1-git-send-email-wangjie88@huawei.com -> patchew/1526517763-11108-1-git-send-email-wangjie88@huawei.com
 * [new tag]               patchew/20180517050024.20101-1-ross.zwisler@linux.intel.com -> patchew/20180517050024.20101-1-ross.zwisler@linux.intel.com
Switched to a new branch 'test'
3a8b0e98fa ACPI testing: test NFIT platform capabilities
5732e8be9b nvdimm, acpi: support NFIT platform capabilities
3808b5f1bc tests/.gitignore: add entry for generated file
fa07ae77c6 nvdimm: fix typo in label-size definition

=== OUTPUT BEGIN ===
Checking PATCH 1/4: nvdimm: fix typo in label-size definition...
Checking PATCH 2/4: tests/.gitignore: add entry for generated file...
Checking PATCH 3/4: nvdimm, acpi: support NFIT platform capabilities...
ERROR: braces {} are necessary for all arms of this statement
#94: FILE: hw/acpi/nvdimm.c:407:
+    if (state->capabilities)
[...]

total: 1 errors, 0 warnings, 157 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Checking PATCH 4/4: ACPI testing: test NFIT platform capabilities...
=== OUTPUT END ===

Test command exited with code: 1


---
Email generated automatically by Patchew [http://patchew.org/].
Please send your feedback to patchew-devel@redhat.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

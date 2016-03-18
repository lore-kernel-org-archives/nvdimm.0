Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qg0-x243.google.com (mail-qg0-x243.google.com
 [IPv6:2607:f8b0:400d:c04::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A803C1A1EEA
 for <linux-nvdimm@lists.01.org>; Fri, 18 Mar 2016 09:48:55 -0700 (PDT)
Received: by mail-qg0-x243.google.com with SMTP id 14so7760446qgg.3
 for <linux-nvdimm@lists.01.org>; Fri, 18 Mar 2016 09:48:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318162450.GA11364@linux.intel.com>
References: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
 <20160317005455.3025.68568.stgit@dwillia2-desk3.jf.intel.com>
 <20160318162450.GA11364@linux.intel.com>
Date: Fri, 18 Mar 2016 09:48:33 -0700
Message-ID: <CAA9_cmc-x8D6Hukt3=A_hbeVx+MNF9P7trCjGe32_TOB7ODAjQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 5/5] ndctl: fall back to nfit_test for
 test/{blk|pmem}-ns
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 18, 2016 at 9:24 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Mar 16, 2016 at 05:54:55PM -0700, Dan Williams wrote:
>> Prevent these tests from bitrotting going forward by arranging for them
>> to be run against nfit_test resources in the case that an ACPI.NFIT
>> provider is not found.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> I'm testing on a system without nfit_test, but with a working block namespace
> and PMEM namespace.
>
> Prior to this change both the blk-ns and pmem-ns tests pass, but with this
> patch they are both skipped.
>
> I'm guessing that it's looking for nfit_test resources, not finding them, and
> then just skipping the test instead of running against my real PMEM & BLK
> namespaces?

Ah, yes, it bails if it can't load nfit_test.ko.  Let me re-order that
a bit.  Thanks Ross!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

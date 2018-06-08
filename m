Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D27C210DF51F
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 22:18:01 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH 2/5] acpi: "make check" should fail on
 asl mismatch
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-2-ross.zwisler@linux.intel.com>
 <20180608020724-mutt-send-email-mst@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Message-ID: <5352d2fb-9244-78b0-4f4b-2818359a4425@redhat.com>
Date: Fri, 8 Jun 2018 07:17:51 +0200
MIME-Version: 1.0
In-Reply-To: <20180608020724-mutt-send-email-mst@kernel.org>
Content-Language: en-US
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
To: "Michael S. Tsirkin" <mst@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 08.06.2018 01:09, Michael S. Tsirkin wrote:
> On Thu, Jun 07, 2018 at 04:31:08PM -0600, Ross Zwisler wrote:
>> Currently if "make check" detects a mismatch in the ASL generated during
>> testing, we print an error such as:
>>
>>   acpi-test: Warning! SSDT mismatch. Actual [asl:/tmp/asl-QZDWJZ.dsl,
>>   aml:/tmp/aml-T8JYJZ], Expected [asl:/tmp/asl-DTWVJZ.dsl,
>>   aml:tests/acpi-test-data/q35/SSDT.dimmpxm].
>>
>> but the testing still exits with good shell status.  This is wrong, and
>> makes bisecting such a failure difficult.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Failing would also mean that any change must update the expected files
> at the same time.  And that in turn is problematic because expected
> files are binary and can't be merged.
> 
> In other words the way we devel ACPI right now means that bisect will
> periodically produce a diff, it's not an error.

But apparently the current way also allows that real bug go unnoticed
for a while, until somebody accidentially spots the warning in the
output of "make check". Wouldn't it be better to fail at CI time
already? If a merge of the file is required, you can still resolve that
manually (i.e. by rebasing one of the pull requests).

 Thomas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F711210E4351
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 16:09:32 -0700 (PDT)
Date: Fri, 8 Jun 2018 02:09:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [qemu PATCH 2/5] acpi: "make check" should fail on asl mismatch
Message-ID: <20180608020724-mutt-send-email-mst@kernel.org>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180607223111.27792-2-ross.zwisler@linux.intel.com>
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
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 07, 2018 at 04:31:08PM -0600, Ross Zwisler wrote:
> Currently if "make check" detects a mismatch in the ASL generated during
> testing, we print an error such as:
> 
>   acpi-test: Warning! SSDT mismatch. Actual [asl:/tmp/asl-QZDWJZ.dsl,
>   aml:/tmp/aml-T8JYJZ], Expected [asl:/tmp/asl-DTWVJZ.dsl,
>   aml:tests/acpi-test-data/q35/SSDT.dimmpxm].
> 
> but the testing still exits with good shell status.  This is wrong, and
> makes bisecting such a failure difficult.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Failing would also mean that any change must update the expected files
at the same time.  And that in turn is problematic because expected
files are binary and can't be merged.

In other words the way we devel ACPI right now means that bisect will
periodically produce a diff, it's not an error.


> ---
>  tests/bios-tables-test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/bios-tables-test.c b/tests/bios-tables-test.c
> index 256d463cb8..9b5db1ee8f 100644
> --- a/tests/bios-tables-test.c
> +++ b/tests/bios-tables-test.c
> @@ -469,6 +469,7 @@ static void test_acpi_asl(test_data *data)
>                      }
>                  }
>            }
> +          g_test_fail();
>          }
>          g_string_free(asl, true);
>          g_string_free(exp_asl, true);
> -- 
> 2.14.4
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 383722210D9C9
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 16:25:12 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id q71-v6so11695993oic.6
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 16:31:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323230849.3754-1-ross.zwisler@linux.intel.com>
References: <20180323230849.3754-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Mar 2018 16:31:44 -0700
Message-ID: <CAPcyv4ht8h=upoJCN4j4jVm89=ZQ9Huq10ahmVsTEMuB4sporw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: fail NUMA filtering when unsupported
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 23, 2018 at 4:08 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> For systems that don't support NUMA, numactl gives a loud and fatal error:
>
>   # numactl -N 0 ls
>   numactl: This system does not support NUMA policy
>
> Follow this model in ndctl for NUMA based filtering:
>
>   # ./ndctl/ndctl list --numa-node=0
>     Error: This system does not support NUMA
>
> This is done instead of just quietly filtering out all dimms, regions and
> namespaces because the NUMA node they were trying to match didn't exist in
> the system.
>
> libnuma tests whether NUMA is enabled via the get_mempolicy() syscall,
> passing in all NULLs and 0s for arguments to always get the default policy.
> See numa_available() in numa(3) and in the numactl source.
>
> ndctl checks sysfs for the existence of the /sys/devices/system/node
> directory to avoid a dependency on libnuma.  If we had a dependency on
> libnuma we would have to choose whether this was fulfilled or not at
> compile time, which would potentially mean that we could be on a
> NUMA-enabled kernel but with an ndctl where NUMA support was disabled.
> It's better to always have NUMA support in ndctl and only depend on the
> kernel config.
>
> I've inspected the code for both get_mempolicy() and the code that creates
> the /sys/devices/system/node directory, and they both seem to completely
> rely on CONFIG_NUMA being defined.  If CONFIG_NUMA is set, get_mempolicy()
> will always be able to return a default policy and /sys/devices/system/node
> will always exist.  Otherwise, both checks will always fail.  So, numactl
> and ndctl should always agree on whether NUMA is supported on a given
> system.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
> v3: Changed back to checking /sys/devices/system/node instead of using
>     libnuma, and added more info to the changelog.

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

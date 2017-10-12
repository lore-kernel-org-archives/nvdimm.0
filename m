From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 1/2] pmem: Move reusable code to base header files
Date: Thu, 12 Oct 2017 13:42:42 -0700
Message-ID: <CAPcyv4jdWUeoF1PxWhXx3vciLmOL9AyW_yPq0W6DRFe3RP2fkA@mail.gmail.com>
References: <20171012155027.3277-1-pagupta@redhat.com> <20171012155027.3277-2-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171012155027.3277-2-pagupta@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@redhat.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Zwisler, Ross" <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Oct 12, 2017 at 8:50 AM, Pankaj Gupta <pagupta@redhat.com> wrote:
>  This patch moves common code to base header files
>  so that it can be used for both ACPI pmem and VIRTIO pmem
>  drivers. More common code needs to be moved out in future
>  based on functionality required for virtio_pmem driver and
>  coupling of code with existing ACPI pmem driver.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
[..]
> diff --git a/include/linux/pmem_common.h b/include/linux/pmem_common.h
> new file mode 100644
> index 000000000000..e2e718c74b3f
> --- /dev/null
> +++ b/include/linux/pmem_common.h

This should be a common C file, not a header.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

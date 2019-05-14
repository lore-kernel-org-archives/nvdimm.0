From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
Date: Tue, 14 May 2019 08:09:03 -0700
Message-ID: <c22d42f6-ef94-0310-36f2-e9085d3464c2@infradead.org>
References: <20190514145422.16923-1-pagupta@redhat.com>
	<20190514145422.16923-3-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20190514145422.16923-3-pagupta@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: jack@suse.cz, mst@redhat.com, david@fromorbit.com, lcapitulino@redhat.com, adilger.kernel@dilger.ca, zwisler@kernel.org, aarcange@redhat.com, dave.jiang@intel.com, jstaron@google.com, darrick.wong@oracle.com, vishal.l.verma@intel.com, willy@infradead.org, hch@infradead.org, jmoyer@redhat.com, nilal@redhat.com, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval.shaia@oracle.com, stefanha@redhat.com, pbonzini@redhat.com, dan.j.williams@intel.com, tytso@mit.edu, xiaoguangrong.eric@gmail.com, cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com
List-Id: linux-nvdimm@lists.01.org

On 5/14/19 7:54 AM, Pankaj Gupta wrote:
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 35897649c24f..94bad084ebab 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -42,6 +42,17 @@ config VIRTIO_PCI_LEGACY
>  
>  	  If unsure, say Y.
>  
> +config VIRTIO_PMEM
> +	tristate "Support for virtio pmem driver"
> +	depends on VIRTIO
> +	depends on LIBNVDIMM
> +	help
> +	This driver provides access to virtio-pmem devices, storage devices
> +	that are mapped into the physical address space - similar to NVDIMMs
> +	 - with a virtio-based flushing interface.
> +
> +	If unsure, say M.

<beep>
from Documentation/process/coding-style.rst:
"Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces."

> +
>  config VIRTIO_BALLOON
>  	tristate "Virtio balloon driver"
>  	depends on VIRTIO

thanks.
-- 
~Randy

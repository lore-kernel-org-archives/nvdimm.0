From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/5] ext4: disable map_sync for virtio pmem
Date: Wed, 9 Jan 2019 15:42:15 +0100
Message-ID: <20190109144215.GI15397@quack2.suse.cz>
References: <20190109135606.15401-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20190109135606.15401-1-pagupta@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: jack@suse.cz, kvm@vger.kernel.org, linux-nvdimm@ml01.01.org, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger.kernel@dilger.ca, zwisler@kernel.org, eblake@redhat.com, dave.jiang@intel.com, darrick.wong@oracle.com, vishal.l.verma@intel.com, mst@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, imammedo@redhat.com, dan.j.williams@intel.com, lcapitulino@redhat.com, linux-ext4@vger.kernel.org, tytso@mit.edu, xiaoguangrong.eric@gmail.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pbonzini@redhat.com
List-Id: linux-nvdimm@lists.01.org

On Wed 09-01-19 19:26:05, Pankaj Gupta wrote:
> Virtio pmem provides asynchronous host page cache flush
> mechanism. We don't support 'MAP_SYNC' with virtio pmem 
> and ext4. 
> 
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
...
> @@ -371,6 +373,13 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (!IS_DAX(file_inode(file)) && (vma->vm_flags & VM_SYNC))
>  		return -EOPNOTSUPP;
>  
> +	/* We don't support synchronous mappings with guest direct access
> +	 * and virtio based host page cache flush mechanism.
> +	 */
> +	if (IS_DAX(file_inode(file)) && virtio_pmem_host_cache_enabled(dax_dev)
> +						&& (vma->vm_flags & VM_SYNC))
> +		return -EOPNOTSUPP;
> +

Shouldn't there rather be some generic way of doing this? Having
virtio_pmem_host_cache_enabled() check in filesystem code just looks like
filesystem sniffing into details is should not care about... Maybe just
naming this (or having a wrapper) dax_dev_map_sync_supported()?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

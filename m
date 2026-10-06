Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3EE414408;
	Tue,  6 Oct 2026 20:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791317492; cv=none; b=vGHwNbx7MmovZM4MnLES25GGnQDWLT33UjuTVFif8wfqFI2pqo7m737cM0CNnZPXvNUAMuP2iLtksP/DXO6xFuaaJzbEBDuoNi2d4WeiRDy6UTJWnKvl/e8s2h1p3ZqEIuEaO0XNiWPek14Sf6QwtsCH4j35MfvFk5FL0I3haFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791317492; c=relaxed/simple;
	bh=rhZTet/5n0tB6bK3dzqTT9pGDhmiAzKrb7Px/pntgj4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=k5mbrS66GsMYFd6oo47ndCAQDj5Vm+jwDMCgxuQXZIwv55PU0ybnYAWlO4VBJ3QIW+966ThQlD3La0QU/sLwuVjK76U3MzMBklaLxarF4VZKyPRv4n0JDfqPd6SxYxv45WP3gmHf8dpVJw47K89u+LQ2nFJlnWBSl05fiiog+II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6149812031D;
	Tue,  6 Oct 2026 20:11:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf03.hostedemail.com (Postfix) with ESMTPA id 29DC66000E;
	Tue,  6 Oct 2026 20:11:26 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9343CF40066;
	Tue,  6 Oct 2026 16:11:25 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Tue, 06 Oct 2026 16:11:25 -0400
X-ME-Sender: <xms:7VXFakwy-dFrgprqg7HMrlG2EC-jQmAy1uwmMicjKBatySMCUEKcUQ>
    <xme:7VXFajGG6WsrMJ-oyazoiAuJEcIgQP9EfoDJwbFdKkCL4xKJqnJuO7XRMvcjdFSLv
    v2g6erQeAHKNyKO2wt2n2zvxb6uBO-eaIsr7eFFy0eAlUXidODSYzE>
X-ME-Proxy-Cause: dmFkZTFk2jcKdXKrdNxs92qlvbpPl60T8mkfMnJibH9QP+oZVHmQYh0CRGexAMSX41UJuV
    JypdQb+sxr1Gr0lwDFh7hHv10T/L1qJ8ulHCYgjrmwoAyFbddAmTyUzlBustpoKm/sfbKP
    qo9ArokUu6PXQVnvowP6zEnCUIVdoEaV39+6o7M7axQCL+EyMIY6epMVSNEpQoNxB8Jq1D
    96HTxi7WiF1rudRj1xf7R6TXkRSIKG61Q3qHnmAlJi04SRk5FrhC9wTjwaBAFEbUoEz/uU
    COBYFNpMyDZodbAnsPxGz4NQJRmcn70mUUFDm9rdJj/VgjzCjKInxKVLNS8NAGYqpk2Vs4
    wMAIpfkdxV0OevhvxOIjRFwEUA20M/ZPRYQ6bTb87a1xkIhJrVK8ntm8bDWkvtyDAw2AzD
    cc8LESS0PEoX601RVCY6MuhWkL8R0PZxy95QvFKT605lbeWLTvNeCCsb2Jsi1eFyp/KUBw
    r4gjaRv7++2LCfYZlemIOm4I60bjt5myW1PFMx7TD4mFR5yUiug7YPHxbsBUlT15z8StfF
    5QE+ns1n5cU6NUpSKIkjPeSbODkUXCzLLXGsZM6MTr3CUorSSKgGEz7InMjgRVud6m7GRw
    MhATIUdHTfArNbamWGTqnAG2Mwc/YsnPlB2VjY6D39NtKeJkj82UbiyUXN6g
X-ME-Proxy: <xmx:7VXFauTB9h01DnkypLZ09mV1_I47_sqJTQ7LZ7x6kCFBHF8vCOtCtg>
    <xmx:7VXFagVNP2LE4GBuMfm_P_PEsEmBGCqAod1pYJ-_2ByXNM__8XJJ-w>
    <xmx:7VXFagSCaH7svvQl2PD9camZjkY4nIX-RnvNOJ0CBkR_rHFFA_iIrA>
    <xmx:7VXFag31cztHmtZIDZZMJ8SHFgqwqgBJmuh-fEEiQ7Wsy4evhUo4Cw>
    <xmx:7VXFaofcoggPQA45-JQF38DPuk5YiFl64gKxnWwFZOvck9cEN2YJfvF7>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6F695700065; Tue,  6 Oct 2026 16:11:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 15:10:49 -0500
From: "John Groves" <john@groves.net>
To: "Miklos Szeredi" <mszeredi@redhat.com>, fuse-devel@lists.linux.dev
Cc: "Amir Goldstein" <amir73il@gmail.com>,
 "Darrick J . Wong" <djwong@kernel.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Alison Schofield" <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Message-Id: <6501a22c-f484-43d4-b109-5d8021cc3dc4@app.fastmail.com>
In-Reply-To: <20261006180115.1425232-5-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-5-mszeredi@redhat.com>
Subject: Re: [PATCH v3 4/9] fuse: support 64 bit, server allocated backing ID
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3hq4t845u5mf9htyuqtorfddb16s9tww
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 29DC66000E
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+5kNAQzlSMT16aF0EdpPEAMgF4oOPmj8A=
X-HE-Tag: 1791317486-26692
X-HE-Meta: U2FsdGVkX18WbJVlaRJ9JslND+bkoahDFYbB7i7s2Ckoe/dB+3g7Hix5zYPk+vPH97IE5PJ5MiHQWFmNAq3nFnO/A23c5ED1D9xpEpxGXyuYOARel0VCIxkUR5ofDUlXzgCz1sqqKrt++d2/WKa9hjtQmByGg7IvlN491rMY6lFDfn80dc/zVXnnh3vmnw8qvMMUVg+6o2mZiqLdQdKIwB618cM6odZukJL436LpuPzEPa8oLGRwN5W8iMaDavg0yCrE2stfYy/IQSIbi5KkPTRDDINrru6LbxmTjmk8PphqXe0hLCA+Y3AfaE3XXRWc9SlzVrxx8gJ8clsU5etn5t+Tb+QdZuYE



On Tue, Oct 6, 2026, at 1:01 PM, Miklos Szeredi wrote:
> Add support for server allocated 64-bit backing IDs alongside the
> existing kernel allocated 32-bit IDs.
> 
> Opened with FUSE_DEV_IOC_BACKING_CREATE, the backing ID sent via
> fuse_backing_create_in.backing_id.
> 
> Closed with FUSE_NOTIFY_BACKING_REMOVE.  Since close only provides the
> backing ID, not the file descriptor, it doesn't have to be done with an
> ioctl.
> 
> Backing ID can take any 64 bit value other than zero.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
> fs/fuse/backing.c         | 179 ++++++++++++++++++++++++++++----------
> fs/fuse/dev.c             |  24 +++++
> fs/fuse/dev.h             |   3 +
> fs/fuse/fuse_i.h          |  24 ++++-
> fs/fuse/inode.c           |  15 +++-
> fs/fuse/notify.c          |  28 ++++++
> fs/fuse/passthrough.c     |   3 +
> include/uapi/linux/fuse.h |  22 ++++-
> 8 files changed, 246 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 433fa3098d71..bc40818778df 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -9,6 +9,7 @@
> #include "fuse_i.h"
>  
> #include <linux/file.h>
> +#include <linux/rhashtable.h>
>  
> static struct fuse_backing *fuse_backing_get(struct fuse_backing *fb)
> {
> @@ -48,6 +49,8 @@ static int fuse_backing_id_alloc(struct fuse_conn *fc, struct fuse_backing *fb)
> id = idr_alloc_cyclic(&fc->backing_files_map, fb, 1, 0, GFP_ATOMIC);
> spin_unlock(&fc->lock);
> idr_preload_end();
> + if (id > 0)
> + fb->backing_id = id;
>  
> WARN_ON_ONCE(id == 0);
> return id;
> @@ -61,81 +64,133 @@ static struct fuse_backing *fuse_backing_id_remove(struct fuse_conn *fc,
> spin_lock(&fc->lock);
> fb = idr_remove(&fc->backing_files_map, id);
> spin_unlock(&fc->lock);
> + if (fb)
> + fb->backing_id = 0;
>  
> return fb;
> }
>  
> -static int fuse_backing_id_free(int id, void *p, void *data)
> -{
> - struct fuse_backing *fb = p;
> +static const struct rhashtable_params fuse_backing_prm = {
> + .head_offset = offsetof(struct fuse_backing, hash_node),
> + .key_offset = offsetof(struct fuse_backing, backing_id),
> + .key_len = sizeof_field(struct fuse_backing, backing_id),
> +};
>  
> - WARN_ON_ONCE(refcount_read(&fb->count) != 1);
> - fuse_backing_free(fb);
> - return 0;
> +static int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb)
> +{
> + return rhashtable_insert_fast(&fc->backing_64_ht, &fb->hash_node, fuse_backing_prm);
> }
>  
> -void fuse_backing_files_free(struct fuse_conn *fc)
> +int fuse_backing_close_64(struct fuse_conn *fc, u64 backing_id)
> {
> - idr_for_each(&fc->backing_files_map, fuse_backing_id_free, NULL);
> - idr_destroy(&fc->backing_files_map);
> + struct fuse_backing *fb;
> + int err;
> +
> + if (!fc->backing_id_64)
> + return -EINVAL;
> +
> + scoped_guard(spinlock, &fc->lock) {
> + fb = rhashtable_lookup_fast(&fc->backing_64_ht, &backing_id, fuse_backing_prm);
> + if (!fb)
> + return -ENOENT;
> +
> + err = rhashtable_remove_fast(&fc->backing_64_ht, &fb->hash_node, fuse_backing_prm);
> + WARN_ON(err);
> + }
> + fb->backing_id = 0;
> + fuse_backing_put(fb);
> +
> + return 0;
> }
>  
> -int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
> +static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int fd)
> {
> - struct file *file;
> + struct fuse_backing *fb;
> struct super_block *backing_sb;
> - struct fuse_backing *fb = NULL;
> - int res;
> -
> - pr_debug("%s: fd=%d flags=0x%x\n", __func__, map->fd, map->flags);
> + struct file *file;
>  
> /* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
> - res = -EPERM;
> if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
> - goto out;
> + return ERR_PTR(-EPERM);
>  
> - res = -EINVAL;
> - if (map->flags || map->padding)
> - goto out;
> + CLASS(fd_raw, f)(fd);
> + if (fd_empty(f))
> + return ERR_PTR(-EBADF);
>  
> - file = fget_raw(map->fd);
> - res = -EBADF;
> - if (!file)
> - goto out;
> + file = fd_file(f);
>  
> /* read/write/splice/mmap passthrough only relevant for regular files */
> - res = d_is_dir(file->f_path.dentry) ? -EISDIR : -EINVAL;
> if (!d_is_reg(file->f_path.dentry))
> - goto out_fput;
> + return d_is_dir(file->f_path.dentry) ? ERR_PTR(-EISDIR) : ERR_PTR(-EINVAL);
>  
> backing_sb = file_inode(file)->i_sb;
> - res = -ELOOP;
> if (backing_sb->s_stack_depth >= fc->max_stack_depth)
> - goto out_fput;
> + return ERR_PTR(-ELOOP);
>  
> fb = kmalloc_obj(struct fuse_backing);
> - res = -ENOMEM;
> if (!fb)
> - goto out_fput;
> + return ERR_PTR(-ENOMEM);
>  
> - fb->file = file;
> + fb->file = get_file(file);
> fb->cred = get_current_cred();
> refcount_set(&fb->count, 1);
>  
> - res = fuse_backing_id_alloc(fc, fb);
> - if (res < 0) {
> + return fb;
> +}
> +
> +int fuse_backing_open_64(struct fuse_conn *fc, struct fuse_backing_create_in *map)
> +{
> + struct fuse_backing *fb;
> + int res;
> +
> + if (map->padding || map->spare[0] || map->spare[1] || !map->backing_id)
> + return -EINVAL;
> +
> + if (!fc->backing_id_64)
> + return -EINVAL;
> +
> + fb = fuse_backing_new(fc, map->fd);
> + if (IS_ERR(fb))
> + return PTR_ERR(fb);
> +
> + fb->backing_id = map->backing_id;
> + res = fuse_backing_add_64(fc, fb);
> + if (res < 0)
> fuse_backing_free(fb);
> - fb = NULL;
> +
> + return res;
> +}
> +
> +int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
> +{
> + struct fuse_backing *fb = NULL;
> + int res;
> +
> + pr_debug("%s: fd=%d flags=0x%x\n", __func__, map->fd, map->flags);
> +
> + res = -EINVAL;
> + if (map->flags || map->padding)
> + goto out;
> +
> + scoped_guard(spinlock, &fc->lock) {
> + if (fc->backing_id_64)
> + goto out;
> + fc->backing_id_32 = true;
> }
>  
> + fb = fuse_backing_new(fc, map->fd);
> + res = PTR_ERR(fb);
> + if (!IS_ERR(fb)) {
> + res = fuse_backing_id_alloc(fc, fb);
> + if (res < 0) {
> + fuse_backing_free(fb);
> + fb = NULL;
> + }
> + }
> out:
> pr_debug("%s: fb=0x%p, ret=%i\n", __func__, fb, res);
>  
> return res;
> -
> -out_fput:
> - fput(file);
> - goto out;
> }
>  
> int fuse_backing_close(struct fuse_conn *fc, int backing_id)
> @@ -145,6 +200,9 @@ int fuse_backing_close(struct fuse_conn *fc, int backing_id)
>  
> pr_debug("%s: backing_id=%d\n", __func__, backing_id);
>  
> + if (fc->backing_id_64)
> + return -EINVAL;
> +
> /* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
> err = -EPERM;
> if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
> @@ -167,14 +225,47 @@ int fuse_backing_close(struct fuse_conn *fc, int backing_id)
> return err;
> }
>  
> -struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, int backing_id)
> +struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id)
> {
> struct fuse_backing *fb;
>  
> - rcu_read_lock();
> - fb = idr_find(&fc->backing_files_map, backing_id);
> - fb = fuse_backing_get(fb);
> - rcu_read_unlock();
> + guard(rcu)();
> + if (!fc->backing_id_64)
> + fb = idr_find(&fc->backing_files_map, backing_id);
> + else
> + fb = rhashtable_lookup(&fc->backing_64_ht, &backing_id, fuse_backing_prm);
>  
> - return fb;
> + return fuse_backing_get(fb);
> +}
> +
> +static void fuse_backing_check_free(struct fuse_backing *fb)
> +{
> + WARN_ON_ONCE(refcount_read(&fb->count) != 1);
> + fuse_backing_free(fb);
> +}
> +
> +static int fuse_backing_idr_free(int id, void *p, void *data)
> +{
> + fuse_backing_check_free(p);
> + return 0;
> +}
> +
> +static void fuse_backing_rht_free(void *p, void *data)
> +{
> + fuse_backing_check_free(p);
> +}
> +
> +void fuse_backing_files_free(struct fuse_conn *fc)
> +{
> + if (fc->backing_id_64) {
> + rhashtable_free_and_destroy(&fc->backing_64_ht, fuse_backing_rht_free, NULL);
> + } else {
> + idr_for_each(&fc->backing_files_map, fuse_backing_idr_free, NULL);
> + idr_destroy(&fc->backing_files_map);
> + }
> +}
> +
> +void fuse_backing_files_init_64(struct fuse_conn *fc)
> +{
> + rhashtable_init(&fc->backing_64_ht, &fuse_backing_prm);
> }
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 2d7ee5498f1c..15876a534ad0 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2339,6 +2339,27 @@ static long fuse_dev_ioctl_backing_open(struct file *file,
> return fuse_backing_open(fud->chan->conn, &map);
> }
>  
> +static long fuse_dev_ioctl_backing_create(struct file *file,
> +   struct fuse_backing_create_in __user *argp)
> +{
> + struct fuse_dev *fud = fuse_get_dev(file);
> + struct fuse_backing_create_in map;
> +
> + if (IS_ERR(fud))
> + return PTR_ERR(fud);
> +
> + if (!smp_load_acquire(&fud->chan->initialized))
> + return -ENOTCONN;
> +
> + if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> + return -EOPNOTSUPP;
> +
> + if (copy_from_user(&map, argp, sizeof(map)))
> + return -EFAULT;
> +
> + return fuse_backing_open_64(fud->chan->conn, &map);
> +}
> +
> static long fuse_dev_ioctl_backing_close(struct file *file, __u32 __user *argp)
> {
> struct fuse_dev *fud = fuse_get_dev(file);
> @@ -2379,6 +2400,9 @@ static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
> case FUSE_DEV_IOC_BACKING_OPEN:
> return fuse_dev_ioctl_backing_open(file, argp);
>  
> + case FUSE_DEV_IOC_BACKING_CREATE:
> + return fuse_dev_ioctl_backing_create(file, argp);
> +
> case FUSE_DEV_IOC_BACKING_CLOSE:
> return fuse_dev_ioctl_backing_close(file, argp);
>  
> diff --git a/fs/fuse/dev.h b/fs/fuse/dev.h
> index f6c47ae0395b..dbffd5bed2f5 100644
> --- a/fs/fuse/dev.h
> +++ b/fs/fuse/dev.h
> @@ -14,6 +14,7 @@ struct fuse_dev;
> struct fuse_args;
> struct fuse_copy_state;
> struct fuse_backing_map;
> +struct fuse_backing_create_in;
> struct file;
> struct folio;
> enum fuse_notify_code;
> @@ -87,6 +88,8 @@ int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
>  
> int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map);
> int fuse_backing_close(struct fuse_conn *fc, int backing_id);
> +int fuse_backing_open_64(struct fuse_conn *fc, struct fuse_backing_create_in *map);
> +int fuse_backing_close_64(struct fuse_conn *fc, u64 backing_id);
>  
> int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size);
> int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index d9ec88028d7b..6def89667409 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -32,6 +32,7 @@
> #include <linux/pid_namespace.h>
> #include <linux/refcount.h>
> #include <linux/user_namespace.h>
> +#include <linux/rhashtable-types.h>
>  
> /** Default max number of pages that can be used in a single read request */
> #define FUSE_DEFAULT_MAX_PAGES_PER_REQ 32
> @@ -92,7 +93,8 @@ struct fuse_submount_lookup {
> struct fuse_backing {
> struct file *file;
> const struct cred *cred;
> -
> + u64 backing_id;
> + struct rhash_head hash_node;
> /* refcount */
> refcount_t count;
> struct rcu_head rcu;
> @@ -689,6 +691,12 @@ struct fuse_conn {
> /** @init_security: Initialize security xattrs when creating a new inode */
> unsigned int init_security:1;
>  
> + /** Legacy 32 bit backing ID */
> + bool backing_id_32:1;
> +
> + /** Backing ID is 64 bit and allocated by the server */
> + bool backing_id_64:1;
> +
> /**
> * @create_supp_group: Add supplementary group info when creating
> * a new inode
> @@ -770,8 +778,14 @@ struct fuse_conn {
> struct fuse_sync_bucket __rcu *curr_bucket;
>  
> #ifdef CONFIG_FUSE_PASSTHROUGH
> - /** @backing_files_map: IDR for backing files ids */
> - struct idr backing_files_map;
> + /* Selected by backing_id_64 */
> + union {
> + /** @backing_files_map: IDR for backing files ids */
> + struct idr backing_files_map;
> +
> + /** @backing_64_ht: 64 bit ID lookup hash table */
> + struct rhashtable backing_64_ht;
> + };
> #endif
> };
>  
> @@ -1270,7 +1284,7 @@ void fuse_file_release(struct inode *inode, struct fuse_file *ff,
> /* backing.c */
> #ifdef CONFIG_FUSE_PASSTHROUGH
> void fuse_backing_put(struct fuse_backing *fb);
> -struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, int backing_id);
> +
> #else
>  
> static inline void fuse_backing_put(struct fuse_backing *fb)
> @@ -1278,7 +1292,9 @@ static inline void fuse_backing_put(struct fuse_backing *fb)
> }
> #endif
>  
> +struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id);
> void fuse_backing_files_init(struct fuse_conn *fc);
> +void fuse_backing_files_init_64(struct fuse_conn *fc);
> void fuse_backing_files_free(struct fuse_conn *fc);
>  
> /* passthrough.c */
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index cbb10e19e7e8..b5b51865d59f 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1408,13 +1408,24 @@ static void process_init_reply(struct fuse_args *args, int error)
> * them together.
> */
> if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) &&
> -     (flags & FUSE_PASSTHROUGH) &&
> +     (flags & (FUSE_PASSTHROUGH | FUSE_PASSTHROUGH_V2)) &&
>     arg->max_stack_depth > 0 &&
>     arg->max_stack_depth <= FILESYSTEM_MAX_STACK_DEPTH &&
>     !(flags & FUSE_WRITEBACK_CACHE))  {
> fc->passthrough = 1;
> fc->max_stack_depth = arg->max_stack_depth;
> fm->sb->s_stack_depth = arg->max_stack_depth;
> + if (flags & FUSE_PASSTHROUGH_V2) {
> + /* Prevent race with fuse_backing_open() */
> + scoped_guard(spinlock, &fc->lock) {
> + if (fc->backing_id_32)
> + ok = false;
> + else
> + fc->backing_id_64 = true;
> + }
> + if (ok)
> + fuse_backing_files_init_64(fc);
> + }
> }
> if (flags & FUSE_NO_EXPORT_SUPPORT)
> fm->sb->s_export_op = &fuse_export_fid_operations;
> @@ -1500,7 +1511,7 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
> if (fm->fc->auto_submounts)
> flags |= FUSE_SUBMOUNTS;
> if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> - flags |= FUSE_PASSTHROUGH;
> + flags |= FUSE_PASSTHROUGH | FUSE_PASSTHROUGH_V2;
> /* Only offered to sufficiently privileged servers; see
> * fuse_syncfs_enable().
> */
> diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
> index c0428e03d138..93e916a16ac9 100644
> --- a/fs/fuse/notify.c
> +++ b/fs/fuse/notify.c
> @@ -409,6 +409,31 @@ static int fuse_notify_prune(struct fuse_conn *fc, unsigned int size,
> return 0;
> }
>  
> +static int fuse_notify_backing_remove(struct fuse_conn *fc, unsigned int size,
> +      struct fuse_copy_state *cs)
> +{
> + struct fuse_notify_backing_remove_out outarg;
> + int err;
> +
> + if (size != sizeof(outarg))
> + return -EINVAL;
> +
> + err = fuse_copy_one(cs, &outarg, sizeof(outarg));
> + if (err)
> + return err;
> +
> + if (outarg.reserved)
> + return -EINVAL;
> +
> + if (!fc->backing_id_64)
> + return -EINVAL;
> +
> + if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> + return -EOPNOTSUPP;
> +
> + return fuse_backing_close_64(fc, outarg.backing_id);
> +}
> +
> int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
> unsigned int size, struct fuse_copy_state *cs)
> {
> @@ -440,6 +465,9 @@ int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
> case FUSE_NOTIFY_PRUNE:
> return fuse_notify_prune(fc, size, cs);
>  
> + case FUSE_NOTIFY_BACKING_REMOVE:
> + return fuse_notify_backing_remove(fc, size, cs);
> +
> default:
> return -EINVAL;
> }
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index 489838462d1e..313c8d7ffc09 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -160,6 +160,9 @@ struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id)
> struct fuse_backing *fb = NULL;
> struct file *backing_file;
>  
> + if (fc->backing_id_64)
> + return ERR_PTR(fuse_EIO("incompatible backing version"));
> +
> if (backing_id <= 0)
> return ERR_PTR(fuse_EIO("invalid backing_id"));
>  
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 10a7f31c4bdf..37e9559783c3 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -251,6 +251,9 @@
>   *
>   *  7.47
>   *  - add FUSE_HAS_SYNCFS opt-in flag for privileged userspace servers
> + *  - add FUSE_PASSTHROUGH_V2
> + *  - add FUSE_DEV_IOC_BACKING_CREATE, struct fuse_backing_create_in
> + *  - add FUSE_NOTIFY_BACKING_REMOVE, struct fuse_notify_backing_remove_out
>   */
>  
> #ifndef _LINUX_FUSE_H
> @@ -473,6 +476,7 @@ struct fuse_file_lock {
>   * with CAP_SYS_ADMIN in the initial user namespace (the same
>   * privilege that mounting virtiofs or fuseblk requires).
>   * Insufficiently privileged servers ignore it.
> + * FUSE_PASSTHROUGH_V2: use 64 bit server allocated backing ID
>   */
> #define FUSE_ASYNC_READ (1 << 0)
> #define FUSE_POSIX_LOCKS (1 << 1)
> @@ -522,6 +526,7 @@ struct fuse_file_lock {
> #define FUSE_REQUEST_TIMEOUT (1ULL << 42)
> #define FUSE_HAS_IO_URING_BUFPOOL (1ULL << 43)
> #define FUSE_HAS_SYNCFS (1ULL << 44)
> +#define FUSE_PASSTHROUGH_V2 (1ULL << 45)
>  
> /**
>   * CUSE INIT request/reply flags
> @@ -709,6 +714,7 @@ enum fuse_notify_code {
> FUSE_NOTIFY_RESEND = 7,
> FUSE_NOTIFY_INC_EPOCH = 8,
> FUSE_NOTIFY_PRUNE = 9,
> + FUSE_NOTIFY_BACKING_REMOVE = 10,
> };
>  
> /* The read buffer is required to be at least 8k, but may be much larger */
> @@ -1159,13 +1165,20 @@ struct fuse_backing_map {
> uint64_t padding;
> };
>  
> +struct fuse_backing_create_in {
> + int32_t fd;
> + uint32_t padding;
> + uint64_t backing_id; /* Zero value is reserved */
> + uint64_t spare[2];
> +};
> +
> /* Device ioctls: */
> #define FUSE_DEV_IOC_MAGIC 229
> #define FUSE_DEV_IOC_CLONE _IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
> -#define FUSE_DEV_IOC_BACKING_OPEN _IOW(FUSE_DEV_IOC_MAGIC, 1, \
> -      struct fuse_backing_map)
> +#define FUSE_DEV_IOC_BACKING_OPEN _IOW(FUSE_DEV_IOC_MAGIC, 1, struct fuse_backing_map)
> #define FUSE_DEV_IOC_BACKING_CLOSE _IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
> #define FUSE_DEV_IOC_SYNC_INIT _IO(FUSE_DEV_IOC_MAGIC, 3)
> +#define FUSE_DEV_IOC_BACKING_CREATE _IOW(FUSE_DEV_IOC_MAGIC, 4, struct fuse_backing_create_in)
>  
> struct fuse_lseek_in {
> uint64_t fh;
> @@ -1193,6 +1206,11 @@ struct fuse_copy_file_range_out {
> uint64_t bytes_copied;
> };
>  
> +struct fuse_notify_backing_remove_out {
> + uint64_t backing_id;
> + uint64_t reserved;
> +};
> +
> #define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
> #define FUSE_SETUPMAPPING_FLAG_READ (1ull << 1)
> struct fuse_setupmapping_in {
> -- 
> 2.54.0
> 
> 

This doesn't build with CONFIG_FUSE=m. Maybe do something like this?


    CLASS(fd_raw, ...) expands to fdget_raw(), which is not exported, so
    fuse fails to link as a module:
    
      ERROR: modpost: fs/fuse/fuse.ko: symbol 'fdget_raw' undefined!
    
    Go back to fget_raw()/fput(), which the code used before the rewrite
    and which is exported.  Keeps O_PATH file descriptors working, unlike
    switching to CLASS(fd, ...).

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index ea6f5d7b2cf5..ec7e1ebb2635 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -183,16 +183,18 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
 static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int fd)
 {
        struct fuse_backing *fb __free(kfree) = kzalloc_obj(*fb);
+       struct file *file;
        int err;
 
        if (!fb)
                return ERR_PTR(-ENOMEM);
 
-       CLASS(fd_raw, f)(fd);
-       if (fd_empty(f))
+       file = fget_raw(fd);
+       if (!file)
                return ERR_PTR(-EBADF);
 
-       err = fuse_backing_open_file(fc, fb, fd_file(f));
+       err = fuse_backing_open_file(fc, fb, file);
+       fput(file);
        if (err)
                return ERR_PTR(err);
 

-John

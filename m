Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE46321A09130
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 09:13:49 -0700 (PDT)
Subject: Re: [PATCH v12 00/12] Adding security support for nvdimm
References: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
 <a21c65b315bcfe2bed7bf6d2de99076a41043df0.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <e5f1894c-e7b8-c2bc-285b-5877ae255b9d@intel.com>
Date: Wed, 10 Oct 2018 09:13:48 -0700
MIME-Version: 1.0
In-Reply-To: <a21c65b315bcfe2bed7bf6d2de99076a41043df0.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "ebiggers3@gmail.com" <ebiggers3@gmail.com>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 10/09/2018 06:35 PM, Williams, Dan J wrote:
> On Mon, 2018-10-08 at 16:55 -0700, Dave Jiang wrote:
>> The following series implements security support for nvdimm. Mostly
>> adding
>> new security DSM support from the Intel NVDIMM DSM spec v1.7, but
>> also
>> adding generic support libnvdimm for other vendors. The most
>> important
>> security features are unlocking locked nvdimms, and updating/setting
>> security
>> passphrase to nvdimms.
>>
>> v12:
>> - Add a mutex for the cached key and remove key_get/key_put messiness
>> (Dan)
>> - Move security code to its own C file and wrap under
>> CONFIG_NVDIMM_SECURITY
>>   in order to fix issue reported by 0-day build without CONFIG_KEYS.
> 
> Going over this a bit more closely here is some proposed cleanups /
> fixes:
> 
> * remove nvdimm_get_key() and just rely on nvdimm->key being not NULL
> under the key_mutex
> 
> * open code nvdimm_check_key_len() checks
> 
> * make all the security op function signatures take an nvdimm rather
> than a dev
> 
> * move the release of nvdimm->key to nvdimm_remove() rather than
> nvdimm_release(), i.e. driver unload vs nvdimm_bus de-registration.
> 
> * rename nvdimm_replace_key to make_kernel_key
> 
> * clean up nvdimm_security_change_key() to a be bit more readable and
> fix a missing key_put()
> 
> 
> Let me know if these look acceptable and I can fold them into the patch
> set.

Looks good. Thanks!

> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index b6381ddbd6c1..429c544e7ac5 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -23,6 +23,7 @@
>  
>  static int nvdimm_probe(struct device *dev)
>  {
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
>  	struct nvdimm_drvdata *ndd;
>  	int rc;
>  
> @@ -51,10 +52,10 @@ static int nvdimm_probe(struct device *dev)
>  	get_device(dev);
>  	kref_init(&ndd->kref);
>  
> -	nvdimm_security_get_state(dev);
> +	nvdimm_security_get_state(nvdimm);
>  
>  	/* unlock DIMM here before touch label */
> -	rc = nvdimm_security_unlock_dimm(dev);
> +	rc = nvdimm_security_unlock_dimm(nvdimm);
>  	if (rc < 0)
>  		dev_warn(dev, "failed to unlock dimm %s\n", dev_name(dev));
>  
> @@ -115,6 +116,9 @@ static int nvdimm_probe(struct device *dev)
>  static int nvdimm_remove(struct device *dev)
>  {
>  	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +	nvdimm_security_release(nvdimm);
>  
>  	if (!ndd)
>  		return 0;
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 2d9915378bbc..84bec3bb025e 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -213,13 +213,7 @@ void nvdimm_clear_locked(struct device *dev)
>  static void nvdimm_release(struct device *dev)
>  {
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
> -	struct key *key;
>  
> -	mutex_lock(&nvdimm->key_mutex);
> -	key = nvdimm_get_key(dev);
> -	if (key)
> -		key_put(key);
> -	mutex_unlock(&nvdimm->key_mutex);
>  	ida_simple_remove(&dimm_ida, nvdimm->id);
>  	kfree(nvdimm);
>  }
> @@ -436,20 +430,20 @@ static ssize_t security_store(struct device *dev,
>  		if (rc != 3)
>  			return -EINVAL;
>  		dev_dbg(dev, "update %#x %#x\n", old_key, new_key);
> -		rc = nvdimm_security_change_key(dev, old_key, new_key);
> +		rc = nvdimm_security_change_key(nvdimm, old_key, new_key);
>  	} else if (sysfs_streq(cmd, "disable")) {
>  		if (rc != 2)
>  			return -EINVAL;
>  		dev_dbg(dev, "disable %#x\n", old_key);
> -		rc = nvdimm_security_disable(dev, old_key);
> +		rc = nvdimm_security_disable(nvdimm, old_key);
>  	} else if (sysfs_streq(buf, "freeze")) {
>  		dev_dbg(dev, "freeze\n");
> -		rc = nvdimm_security_freeze_lock(dev);
> +		rc = nvdimm_security_freeze_lock(nvdimm);
>  	} else if (sysfs_streq(cmd, "erase")) {
>  		if (rc != 2)
>  			return -EINVAL;
>  		dev_dbg(dev, "erase %#x\n", old_key);
> -		rc = nvdimm_security_erase(dev, old_key);
> +		rc = nvdimm_security_erase(nvdimm, old_key);
>  	} else
>  		return -EINVAL;
>  
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 08e442632a2d..45fcaf45ba2c 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -425,48 +425,47 @@ const u8 *nd_dev_to_uuid(struct device *dev);
>  bool pmem_should_map_pages(struct device *dev);
>  
>  #ifdef CONFIG_NVDIMM_SECURITY
> -struct key *nvdimm_get_key(struct device *dev);
> -int nvdimm_security_unlock_dimm(struct device *dev);
> -int nvdimm_security_get_state(struct device *dev);
> -int nvdimm_security_change_key(struct device *dev, unsigned int old_keyid,
> +int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm);
> +void nvdimm_security_release(struct nvdimm *nvdimm);
> +int nvdimm_security_get_state(struct nvdimm *nvdimm);
> +int nvdimm_security_change_key(struct nvdimm *nvdimm, unsigned int old_keyid,
>  		unsigned int new_keyid);
> -int nvdimm_security_disable(struct device *dev, unsigned int keyid);
> -int nvdimm_security_freeze_lock(struct device *dev);
> -int nvdimm_security_erase(struct device *dev, unsigned int keyid);
> +int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
> +int nvdimm_security_freeze_lock(struct nvdimm *nvdimm);
> +int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
>  #else
> -static inline struct key *nvdimm_get_key(struct device *dev)
> +static inline int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
>  {
> -	return NULL;
> +	return 0;
>  }
>  
> -static inline int nvdimm_security_unlock_dimm(struct device *dev)
> +static inline void nvdimm_security_release(struct nvdimm *nvdimm)
>  {
> -	return 0;
>  }
>  
> -static inline int nvdimm_security_get_state(struct device *dev)
> +static inline int nvdimm_security_get_state(struct nvdimm *nvdimm)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int nvdimm_security_change_key(struct device *dev,
> +static inline int nvdimm_security_change_key(struct nvdimm *nvdimm,
>  		unsigned int old_keyid, unsigned int new_keyid)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int nvdimm_security_disable(struct device *dev,
> +static inline int nvdimm_security_disable(struct nvdimm *nvdimm,
>  		unsigned int keyid)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int nvdimm_security_freeze_lock(struct device *dev)
> +static inline int nvdimm_security_freeze_lock(struct nvdimm *nvdimm)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int nvdimm_security_erase(struct device *dev,
> +static inline int nvdimm_security_erase(struct nvdimm *nvdimm,
>  		unsigned int keyid)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 9f468f91263d..776c440a02ef 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -13,31 +13,13 @@
>  #include "nd-core.h"
>  #include "nd.h"
>  
> -/*
> - * Find key that's cached with nvdimm.
> - */
> -struct key *nvdimm_get_key(struct device *dev)
> -{
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -
> -	if (!nvdimm->key)
> -		return NULL;
> -
> -	if (key_validate(nvdimm->key) < 0)
> -		return NULL;
> -
> -	dev_dbg(dev, "%s: key found: %#x\n", __func__,
> -			key_serial(nvdimm->key));
> -	return nvdimm->key;
> -}
> -
>  /*
>   * Replacing the user key with a kernel key. The function expects that
>   * we hold the sem for the key passed in. The function will release that
>   * sem when done process. We will also hold the sem for the valid new key
>   * returned.
>   */
> -static struct key *nvdimm_replace_key(struct key *key)
> +static struct key *make_kernel_key(struct key *key)
>  {
>  	struct key *new_key;
>  	struct user_key_payload *payload;
> @@ -86,9 +68,8 @@ static struct key *nvdimm_lookup_user_key(struct device *dev,
>  /*
>   * Retrieve kernel key for DIMM and request from user space if necessary.
>   */
> -static struct key *nvdimm_request_key(struct device *dev)
> +static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
>  	struct key *key = NULL;
>  	char desc[NVDIMM_KEY_DESC_LEN + sizeof(NVDIMM_PREFIX)];
>  
> @@ -100,34 +81,26 @@ static struct key *nvdimm_request_key(struct device *dev)
>  	return key;
>  }
>  
> -static int nvdimm_check_key_len(unsigned short len)
> -{
> -	if (len == NVDIMM_PASSPHRASE_LEN)
> -		return 0;
> -
> -	return -EINVAL;
> -}
> -
> -struct key *nvdimm_get_and_verify_key(struct device *dev,
> +struct key *nvdimm_get_and_verify_key(struct nvdimm *nvdimm,
>  		unsigned int user_key_id)
>  {
> +	int rc;
>  	struct key *user_key, *key;
> +	struct device *dev = &nvdimm->dev;
>  	struct user_key_payload *upayload, *payload;
> -	int rc = 0;
>  
> -	key = nvdimm_get_key(dev);
> -	/* we don't have a cached key */
> +	lockdep_assert_held(&nvdimm->key_mutex);
> +	key = nvdimm->key;
>  	if (!key) {
>  		dev_dbg(dev, "No cached kernel key\n");
> -		return NULL;
> +		return ERR_PTR(-EAGAIN);;
>  	}
>  	dev_dbg(dev, "cached_key: %#x\n", key_serial(key));
>  
>  	user_key = nvdimm_lookup_user_key(dev, user_key_id);
>  	if (!user_key) {
>  		dev_dbg(dev, "Old user key lookup failed\n");
> -		rc = -EINVAL;
> -		goto out;
> +		return ERR_PTR(-EINVAL);
>  	}
>  	dev_dbg(dev, "user_key: %#x\n", key_serial(user_key));
>  
> @@ -136,45 +109,38 @@ struct key *nvdimm_get_and_verify_key(struct device *dev,
>  	payload = key->payload.data[0];
>  	upayload = user_key->payload.data[0];
>  
> -	if (memcmp(payload->data, upayload->data,
> -				NVDIMM_PASSPHRASE_LEN) != 0) {
> -		rc = -EINVAL;
> -		dev_warn(dev, "Supplied old user key fails check.\n");
> -	}
> -
> +	rc = memcmp(payload->data, upayload->data, NVDIMM_PASSPHRASE_LEN);
>  	up_read(&user_key->sem);
>  	key_put(user_key);
>  	up_read(&key->sem);
>  
> -out:
> -	if (rc < 0)
> -		key = ERR_PTR(rc);
> +	if (rc != 0) {
> +		dev_warn(dev, "Supplied old user key fails check.\n");
> +		return ERR_PTR(-EINVAL);
> +	}
>  	return key;
>  }
>  
> -int nvdimm_security_get_state(struct device *dev)
> +int nvdimm_security_get_state(struct nvdimm *nvdimm)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -
>  	if (!nvdimm->security_ops)
>  		return 0;
>  
>  	return nvdimm->security_ops->state(nvdimm, &nvdimm->state);
>  }
>  
> -int nvdimm_security_erase(struct device *dev, unsigned int keyid)
> +int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> +	int rc = 0;
>  	struct key *key;
>  	struct user_key_payload *payload;
> -	int rc = 0;
> +	struct device *dev = &nvdimm->dev;
>  	bool is_userkey = false;
>  
>  	if (!nvdimm->security_ops)
>  		return -EOPNOTSUPP;
>  
> -	nvdimm_bus_lock(&nvdimm_bus->dev);
> +	nvdimm_bus_lock(dev);
>  	mutex_lock(&nvdimm->key_mutex);
>  	if (atomic_read(&nvdimm->busy)) {
>  		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
> @@ -195,7 +161,7 @@ int nvdimm_security_erase(struct device *dev, unsigned int keyid)
>  	}
>  
>  	/* look for a key from cached key if exists */
> -	key = nvdimm_get_and_verify_key(dev, keyid);
> +	key = nvdimm_get_and_verify_key(nvdimm, keyid);
>  	if (IS_ERR(key)) {
>  		dev_dbg(dev, "Unable to get and verify key\n");
>  		rc = PTR_ERR(key);
> @@ -229,14 +195,13 @@ int nvdimm_security_erase(struct device *dev, unsigned int keyid)
>  
>   out:
>  	mutex_unlock(&nvdimm->key_mutex);
> -	nvdimm_bus_unlock(&nvdimm_bus->dev);
> -	nvdimm_security_get_state(dev);
> +	nvdimm_bus_unlock(dev);
> +	nvdimm_security_get_state(nvdimm);
>  	return rc;
>  }
>  
> -int nvdimm_security_freeze_lock(struct device *dev)
> +int nvdimm_security_freeze_lock(struct nvdimm *nvdimm)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
>  	int rc;
>  
>  	if (!nvdimm->security_ops)
> @@ -249,16 +214,16 @@ int nvdimm_security_freeze_lock(struct device *dev)
>  	if (rc < 0)
>  		return rc;
>  
> -	nvdimm_security_get_state(dev);
> +	nvdimm_security_get_state(nvdimm);
>  	return 0;
>  }
>  
> -int nvdimm_security_disable(struct device *dev, unsigned int keyid)
> +int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -	struct key *key;
>  	int rc;
> +	struct key *key;
>  	struct user_key_payload *payload;
> +	struct device *dev = &nvdimm->dev;
>  	bool is_userkey = false;
>  
>  	if (!nvdimm->security_ops)
> @@ -269,7 +234,7 @@ int nvdimm_security_disable(struct device *dev, unsigned int keyid)
>  
>  	mutex_lock(&nvdimm->key_mutex);
>  	/* look for a key from cached key */
> -	key = nvdimm_get_and_verify_key(dev, keyid);
> +	key = nvdimm_get_and_verify_key(nvdimm, keyid);
>  	if (IS_ERR(key)) {
>  		mutex_unlock(&nvdimm->key_mutex);
>  		return PTR_ERR(key);
> @@ -304,17 +269,16 @@ int nvdimm_security_disable(struct device *dev, unsigned int keyid)
>  
>   out:
>  	mutex_unlock(&nvdimm->key_mutex);
> -	nvdimm_security_get_state(dev);
> +	nvdimm_security_get_state(nvdimm);
>  	return rc;
>  }
>  
> -int nvdimm_security_unlock_dimm(struct device *dev)
> +int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
>  	struct key *key;
> +	int rc = -ENXIO;
>  	struct user_key_payload *payload;
> -	int rc;
> -	bool cached_key = false;
> +	struct device *dev = &nvdimm->dev;
>  
>  	if (!nvdimm->security_ops)
>  		return 0;
> @@ -325,24 +289,19 @@ int nvdimm_security_unlock_dimm(struct device *dev)
>  		return 0;
>  
>  	mutex_lock(&nvdimm->key_mutex);
> -	key = nvdimm_get_key(dev);
> -	if (!key)
> -		key = nvdimm_request_key(dev);
> -	else
> -		cached_key = true;
> +	key = nvdimm->key;
>  	if (!key) {
> -		mutex_unlock(&nvdimm->key_mutex);
> -		return -ENXIO;
> -	}
> -
> -	if (!cached_key) {
> -		rc = nvdimm_check_key_len(key->datalen);
> -		if (rc < 0) {
> +		key = nvdimm_request_key(nvdimm);
> +		if (key && key->datalen != NVDIMM_PASSPHRASE_LEN) {
>  			key_put(key);
> -			mutex_unlock(&nvdimm->key_mutex);
> -			return rc;
> +			key = NULL;
> +			rc = -EINVAL;
>  		}
>  	}
> +	if (!key) {
> +		mutex_unlock(&nvdimm->key_mutex);
> +		return rc;
> +	}
>  
>  	dev_dbg(dev, "%s: key: %#x\n", __func__, key_serial(key));
>  	down_read(&key->sem);
> @@ -352,7 +311,7 @@ int nvdimm_security_unlock_dimm(struct device *dev)
>  	up_read(&key->sem);
>  
>  	if (rc == 0) {
> -		if (!cached_key)
> +		if (!nvdimm->key)
>  			nvdimm->key = key;
>  		nvdimm->state = NVDIMM_SECURITY_UNLOCKED;
>  		dev_dbg(dev, "DIMM %s unlocked\n", dev_name(dev));
> @@ -364,18 +323,31 @@ int nvdimm_security_unlock_dimm(struct device *dev)
>  	}
>  
>  	mutex_unlock(&nvdimm->key_mutex);
> -	nvdimm_security_get_state(dev);
> +	nvdimm_security_get_state(nvdimm);
>  	return rc;
>  }
>  
> -int nvdimm_security_change_key(struct device *dev,
> +void nvdimm_security_release(struct nvdimm *nvdimm)
> +{
> +	mutex_lock(&nvdimm->key_mutex);
> +	key_put(nvdimm->key);
> +	nvdimm->key = NULL;
> +	mutex_unlock(&nvdimm->key_mutex);
> +}
> +
> +static void key_destroy(struct key *key)
> +{
> +	key_invalidate(key);
> +	key_put(key);
> +}
> +
> +int nvdimm_security_change_key(struct nvdimm *nvdimm,
>  		unsigned int old_keyid, unsigned int new_keyid)
>  {
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -	struct key *key, *old_key;
>  	int rc;
> +	struct key *key, *old_key;
>  	void *old_data = NULL, *new_data;
> -	bool update = false;
> +	struct device *dev = &nvdimm->dev;
>  	struct user_key_payload *payload, *old_payload;
>  
>  	if (!nvdimm->security_ops)
> @@ -386,16 +358,15 @@ int nvdimm_security_change_key(struct device *dev,
>  
>  	mutex_lock(&nvdimm->key_mutex);
>  	/* look for a key from cached key if exists */
> -	old_key = nvdimm_get_and_verify_key(dev, old_keyid);
> -	if (IS_ERR(old_key)) {
> +	old_key = nvdimm_get_and_verify_key(nvdimm, old_keyid);
> +	if (IS_ERR(old_key) && PTR_ERR(old_key) == -EAGAIN)
> +		old_key = NULL;
> +	else if (IS_ERR(old_key)) {
>  		mutex_unlock(&nvdimm->key_mutex);
>  		return PTR_ERR(old_key);
> -	}
> -	if (old_key) {
> -		dev_dbg(dev, "%s: old key: %#x\n",
> -				__func__, key_serial(old_key));
> -		update = true;
> -	}
> +	} else
> +		dev_dbg(dev, "%s: old key: %#x\n", __func__,
> +				key_serial(old_key));
>  
>  	/* request new key from userspace */
>  	key = nvdimm_lookup_user_key(dev, new_keyid);
> @@ -409,22 +380,29 @@ int nvdimm_security_change_key(struct device *dev,
>  
>  	down_read(&key->sem);
>  	payload = key->payload.data[0];
> -	rc = nvdimm_check_key_len(payload->datalen);
> -	if (rc < 0) {
> +	if (payload->datalen != NVDIMM_PASSPHRASE_LEN) {
> +		rc = -EINVAL;
>  		up_read(&key->sem);
>  		goto out;
>  	}
>  
> -	if (!update)
> -		key = nvdimm_replace_key(key);
> +	/*
> +	 * Since there is no existing key this user key will become the
> +	 * kernel's key.
> +	 */
> +	if (!old_key) {
> +		key = make_kernel_key(key);
> +		if (!key) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +	}
>  
>  	/*
>  	 * We don't need to release key->sem here because
> -	 * nvdimm_replace_key() will.
> +	 * make_kernel_key() will have upgraded the user key to kernel
> +	 * and handled the semaphore handoff.
>  	 */
> -	if (!key)
> -		goto out;
> -
>  	payload = key->payload.data[0];
>  
>  	if (old_key) {
> @@ -437,25 +415,26 @@ int nvdimm_security_change_key(struct device *dev,
>  
>  	rc = nvdimm->security_ops->change_key(nvdimm, old_data,
>  			new_data);
> -	/* copy new payload to old payload */
> -	if (rc == 0) {
> -		if (update)
> +	if (rc)
> +		dev_warn(dev, "key update failed: %d\n", rc);
> +
> +	if (old_key) {
> +		/* copy new payload to old payload */
> +		if (rc == 0)
>  			key_update(make_key_ref(old_key, 1), new_data,
>  					old_key->datalen);
> -	} else
> -		dev_warn(dev, "key update failed\n");
> -	if (old_key)
>  		up_read(&old_key->sem);
> +	}
>  	up_read(&key->sem);
>  
> -	if (!update) {
> +	if (!old_key) {
>  		if (rc == 0) {
>  			dev_dbg(dev, "key cached: %#x\n", key_serial(key));
>  			nvdimm->key = key;
>  		} else
> -			key_invalidate(key);
> +			key_destroy(key);
>  	}
> -	nvdimm_security_get_state(dev);
> +	nvdimm_security_get_state(nvdimm);
>  
>   out:
>  	mutex_unlock(&nvdimm->key_mutex);
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

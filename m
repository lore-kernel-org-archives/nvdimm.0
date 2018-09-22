Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59AE8211546FA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 17:25:15 -0700 (PDT)
Subject: Re: [PATCH v8 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
References: <153549647177.4089.18112512093259339717.stgit@djiang5-desk3.ch.intel.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <19459.1537574236@warthog.procyon.org.uk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c804ec81-68c5-3e11-c65f-1226e68a4b2b@intel.com>
Date: Fri, 21 Sep 2018 17:25:08 -0700
MIME-Version: 1.0
In-Reply-To: <19459.1537574236@warthog.procyon.org.uk>
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
To: David Howells <dhowells@redhat.com>
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 09/21/2018 04:57 PM, David Howells wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> +	new_key = key_alloc(&key_type_logon, key->description,
>> +			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, &init_cred, 0,
> 
> KEY_POS_SEARCH?  KEY_USR_VIEW?
> 
>> +			KEY_ALLOC_NOT_IN_QUOTA, NULL);
>> + ...
>> +	down_read(&key->sem);
>> +	payload = key->payload.data[0];
>> +	rc = key_instantiate_and_link(new_key, payload->data, key->datalen,
> 
> payload->datalen, not key->datalen.
> 
>> +			nvdimm_keyring, NULL);
> 
> Okay, that's a weird way of going about things.  I presume you don't want to
> add key to nvdimm_keyring - maybe in case it gets updated whilst you're using
> it and your private key isn't in quota?
> 
>> +	up_read(&key->sem);
>> +	if (rc < 0) {
>> +		key_revoke(new_key);
>> +		key_put(new_key);
>> +		return NULL;
>> +	}
> 
> Just putting it here should work since it didn't get linked to the keyring if
> any errors occurred.  Revoking it too shouldn't be necessary.
> 
>> +	key_invalidate(key);
>> +	key_put(key);
> 
> Why are you invalidating the user's key?
> 
>> +	keyref = lookup_user_key(id, 0, 0);
> 
> KEY_NEED_SEARCH?  Though I suppose it's not strictly necessary as it's a key
> that's private to the kernel.
> 
>> +	if (old_keyid != 0) {
>> +		old_key = nvdimm_get_key(dev);
>> +		if (old_key) {
>> +			if (key_serial(old_key) != old_keyid) {
> 
> Ummm...  That's not what I meant.  Given the permissions you've set on your
> private key, userspace shouldn't be able to find it, let alone give you the
> key ID.
> 
> What I meant here was to use, say, nvdimm_lookup_user_key() to get a key from
> userspace that contains the old password.  You can use the description of the
> key to search nvdimm_keyring for the private key and then compare the
> passwords.

Ok I have a bit of confusion here. When the user injects a new key with
the same description and new passphrase, would that not replace the
existing user key with the old passphrase? Also, if I'm calling
lookup_user_key, where would the key_id come from for the old user key?
I suppose I can cache it.... Maybe I'm not quite understanding the exact
flow of how things you are suggesting.

> 
> Then you don't need to passphrases in the new key.
> 
>> +	rc = nvdimm_check_key_len(key->datalen, update);
> 
> payload->datalen.
> 
>> +	down_read(&key->sem);
> 
> This needs to be earlier.  The payload attached to the new key can be replaced
> by keyctl_update() at any time whilst you're not holding the lock, so you
> cannot use key->payload[*] without holding the lock or the RCU read lock.
> 
>> +	if (update)
>> +		key_invalidate(key);
> 
> The key doesn't belong to you - should you really be invalidating it?
> 
>> +	else {
>> +		key_link(nvdimm_keyring, key);
>> +		nvdimm->key = key;
>> +		key->perm |= KEY_USR_SEARCH;
>> +	}
> 
> Um - do you really want to be taking the key into your internal keyring?  Why
> aren't you calling nvdimm_replace_key()?  Also, you shouldn't alter the
> permission - it's not your key.
> 
>> +static int __parse_update(const char *buf, size_t len, unsigned int *old_id,
>> +		unsigned int *new_id)
>> +{
> 
> Try using sscanf()?
> 
> David
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

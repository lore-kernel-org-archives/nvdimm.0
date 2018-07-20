Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E250021BADAB2
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 09:41:14 -0700 (PDT)
Subject: Re: [PATCH v5 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
References: <4d79bd7b-c992-8259-2408-100756b9983e@intel.com>
 <0a5ba1eb-01d2-b0f2-5e67-262fdb488bb7@intel.com>
 <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <9360.1531912457@warthog.procyon.org.uk>
 <19525.1531988520@warthog.procyon.org.uk>
 <9090.1532101203@warthog.procyon.org.uk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7f826777-c9bd-d602-a8d5-613adc6b4a94@intel.com>
Date: Fri, 20 Jul 2018 09:40:02 -0700
MIME-Version: 1.0
In-Reply-To: <9090.1532101203@warthog.procyon.org.uk>
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
Cc: linux-nvdimm@lists.01.org, keyrings@vger.kernel.org, alison.schofield@intel.com, keescook@chromium.org
List-ID: <linux-nvdimm@lists.01.org>



On 07/20/2018 08:40 AM, David Howells wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>>> Can you show me the whole file?
>> https://lists.01.org/pipermail/linux-nvdimm/2018-July/016958.html
> 
> Is that exactly what's in your /etc/request-key.conf?
No, I realized that I had to do update when converted to logon key. This
is what I added to /etc/request-key.conf:
create   logon   nvdimm*          *      /usr/sbin/nvdimm-upcall %k

I do have it working now.

> 
>>> As I understand it, you poke an attribute file in sysfs by writing
>>> "update" to it and this triggers a request_key() call.  The kernel then
>>> links the key it found across to the internal keyring.
>>
>> Correct. And when there isn't a key, it needs to fetch from userspace
>> and construct the key.
> 
> I think I've missed a step.  Am I right in thinking that the "update" command
> is just for changing the password, and is not the primary way that passwords
> get into the kernel to, say, unlock the device?

That is correct. There is an unlock operation. But we do not expose that
to the userspace via the sysfs knob. Unlock only happens during NVDIMM
discovery/init. Mainly the security is to prevent someone taking the
NVDIMM to another server or take it out of data center. The update
command either enables security and add a passphrase to the NVDIMM or
change the passphrase on a NVDIMM.

> 
>>> You could instead require that the key be specified directly, ie. you
>>> write "update <keyid>" to the attribute file.  The driver can then call
>>> key_lookup() to get the key - or, better still, we should make
>>> lookup_user_key() available so that you can call that - which will do a
>>> security check.
>>
>> I can attach the keyid to the nvdimm when I initially get a success key
>> and the update can look it up easily enough. I'm not groking the
>> lookup_user_key() comment. What determines a key to be a user key or a
>> kernel key?
> 
> lookup_user_key() converts a key serial number into a key applies all the
> security checks to make sure that userspace is allowed to use that key for
> some purpose.
> 
> key_lookup(), on the other hand, has no security checks whatsoever.
> 
> So if you're using a key ID given to you by userspace, you have to use
> lookup_user_key().  Whereas if you want to find a key by description - and
> potentially create it - you use request_key().  request_key() also does all
> the appropriate security checks.
> 
> So I would be tempted to make the update command take an explicit key ID
> rather than calling request_key() - particularly as you want to control what
> the password gets changed to.  Possibly even make it take *two* explicit key
> IDs: the key holding the new password and the key holding the old one.  Then
> you can have security checks on both and you can compare the descriptions to
> make sure they're the same.

Ok let me paraphrase what you are saying and see if I understand.
The current implementation for change password:
1. trigger update via sysfs
2. kernel looks for key in keyring
3. kernel fetches key from userspace if no key in kernel keyring
4. kernel adds new key to keyring

New:
1. userspace inject key into kernel keyring
2. userspace triggers update with new key id and old key id
3. kernel looks up keys with key-id in kernel
4. kernel tries to update with hardware
5. on success kernel accepts new key (or update old key payload)

This pushes most of the complexity into userspace and is more secure.
But I'm not sure if we need it. The admin with root access has access to
everything already. We are just trying to protect against someone moving
the DIMM w/o the right authority. Also, unlock right now basically is a
request-key to userspace to retrieve the key before we unlock. If we go
the other way it sounds like we need to inject all the keys from
userspace first before unlock can happen? Doesn't this mean we'll end up
having to call request-key anyhow in order to trigger an upcall app to
do all this? Also we can't wait until userland comes up and execute an
app to inject all the user keys before we initialize the DIMMs if we
aren't going through request-key upcall.

Also, this is step one. Eventually we would like to be able to just
retrieve the passphrase from TPM instead of the fs or network.

I do think associating with the current key id with the nvdimm object
can make things a lot easier and I can just do key_lookup() instead of
calling request_key().

What about:
1. user triggers update through sysfs
2. kernel fetches old key with key-id that's associated with the nvdimm
object from keyring
3. kernel request_key from userspace for new key
4. kernel sends both payloads to hardware to attempt update
5. on success kernel invalidates old key and updates key-id associated
with the nvdimm object

In this case, all the other security ops should be able to lookup the
key via key-id if that exists. Or they would request-key if the key does
not exist (if the op is first to execute).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
